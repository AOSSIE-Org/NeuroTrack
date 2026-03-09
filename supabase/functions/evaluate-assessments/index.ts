import { createClient } from "@supabase/supabase-js";

import {
  AssessmentDTO,
  QuestionDTO,
  OptionDTO,
  AssessmentEvaluationRequestDTO,
  AssessmentEvaluationQuestionDTO,
} from "./dto/types.ts";

const JSON_HEADERS = { "Content-Type": "application/json" };

/**
 * Supabase Edge Function to evaluate an autism assessment.
 *
 * This function:
 * 1. Authenticates the user via JWT from the Authorization header.
 * 2. Receives a request containing `assessment_id` and `questions` (answered by the user).
 * 3. Fetches the assessment data from the `assessments` table in Supabase.
 * 4. Calculates the total score based on the user's answers.
 * 5. Compares the total score with the assessment's cutoff score.
 * 6. Returns a JSON response indicating whether the user is likely autistic.
 *
 * @param {Request} req - The HTTP request object containing JSON payload.
 * @returns {Response} - A JSON response with the assessment results.
 */

Deno.serve(async (req) => {
  try {
    const authHeader = req.headers.get("Authorization");

    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing Authorization header" }),
        { status: 401, headers: JSON_HEADERS }
      );
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      {
        global: {
          headers: { Authorization: authHeader },
        },
      }
    );

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();

    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: "Unauthorized: Invalid or expired token" }),
        { status: 401, headers: JSON_HEADERS }
      );
    }

    let body: unknown;
    try {
      body = await req.json();
    } catch {
      return new Response(
        JSON.stringify({ error: "Invalid JSON payload" }),
        { status: 400, headers: JSON_HEADERS }
      );
    }

    if (
      !body ||
      typeof body !== "object" ||
      typeof (body as { assessment_id?: unknown }).assessment_id !== "string" ||
      !Array.isArray((body as { questions?: unknown }).questions)
    ) {
      return new Response(
        JSON.stringify({
          error: "Invalid payload: assessment_id and questions are required",
        }),
        { status: 400, headers: JSON_HEADERS }
      );
    }

    const { assessment_id, questions } = body as {
      assessment_id: string;
      questions: unknown[];
    };

    for (let i = 0; i < questions.length; i++) {
      const item = questions[i];
      if (
        !item ||
        typeof item !== "object" ||
        typeof (item as { question_id?: unknown }).question_id !== "string" ||
        typeof (item as { answer_id?: unknown }).answer_id !== "string"
      ) {
        return new Response(
          JSON.stringify({
            error: `Invalid question at index ${i}: question_id and answer_id are required`,
          }),
          { status: 400, headers: JSON_HEADERS }
        );
      }
    }

    const validatedQuestions = questions as AssessmentEvaluationQuestionDTO[];

    const patient_id = user.id;

    const { data, error } = await supabase
      .from("assessments")
      .select("*")
      .eq("id", assessment_id)
      .single();

    if (!data) {
      return new Response(
        JSON.stringify({ error: "Assessment not found" }),
        { status: 404, headers: JSON_HEADERS }
      );
    }

    if (error) {
      return new Response(
        JSON.stringify({ error: "Internal Server Error" }),
        { status: 500, headers: JSON_HEADERS }
      );
    }

    const answered_questions: AssessmentEvaluationRequestDTO = {
      assessment_id: assessment_id,
      questions: validatedQuestions.map((q: AssessmentEvaluationQuestionDTO) => ({
        question_id: q.question_id,
        answer_id: q.answer_id,
      })),
    };

    const assessment: AssessmentDTO = {
      name: data.name,
      description: data.description,
      category: data.category,
      cutoff_score: data.cutoff_score,
      questions: data.questions.map((q: QuestionDTO) => ({
        question_id: q.question_id,
        text: q.text,
        options: q.options.map((o: OptionDTO) => ({
          option_id: o.option_id,
          text: o.text,
          score: o.score,
        })),
      })),
    };

    let totalScore = 0;

    const seenQuestionIds = new Set<string>();
    for (let i = 0; i < answered_questions.questions.length; i++) {
      const question = answered_questions.questions[i];

      if (seenQuestionIds.has(question.question_id)) {
        return new Response(
          JSON.stringify({ error: "Duplicate question_id in submission" }),
          { status: 400, headers: JSON_HEADERS }
        );
      }
      seenQuestionIds.add(question.question_id);

      const matched_question = assessment.questions.find(
        (q) => q.question_id === question.question_id
      );

      if (!matched_question) {
        return new Response(
          JSON.stringify({ error: "Invalid question_id in submission" }),
          { status: 400, headers: JSON_HEADERS }
        );
      }

      const answer = matched_question.options.find(
        (o) => o.option_id === question.answer_id
      );

      if (!answer) {
        return new Response(
          JSON.stringify({ error: "Invalid answer_id for question" }),
          { status: 400, headers: JSON_HEADERS }
        );
      }

      totalScore += answer.score;
    }

    const isAutistic = totalScore >= assessment.cutoff_score;

    const responseData = {
      assessment_score: totalScore,
      is_autistic: isAutistic,
      message: isAutistic
        ? "The assessment indicates a likelihood of autism. Further evaluation is recommended."
        : "The assessment does not indicate autism, but professional consultation is advised if needed.",
    };

    const { error: insertError } = await supabase
      .from("assessment_results")
      .upsert({
        assessment_id: assessment_id,
        submission: answered_questions,
        patient_id: patient_id,
        result: responseData,
      }, { onConflict: 'patient_id,assessment_id', ignoreDuplicates: true });

    if (insertError) {
      const code = (insertError as { code?: string }).code;
      const message = (insertError as { message?: string }).message || "";
      const lowerMessage = message.toLowerCase();

      let status = 500;

      if (
        code === "42501" ||
        lowerMessage.includes("permission denied") ||
        lowerMessage.includes("rls") ||
        lowerMessage.includes("not authorized")
      ) {
        status = 403;
      } else if (code && (code.startsWith("22") || code.startsWith("23"))) {
        status = 400;
      }

      return new Response(
        JSON.stringify({ error: "Failed to save assessment result" }),
        { status, headers: JSON_HEADERS }
      );
    }

    return new Response(JSON.stringify(responseData), {
      headers: JSON_HEADERS,
      status: 200,
    });
  } catch (err) {
    const errorPayload = {
      message: err instanceof Error ? err.message : String(err),
      stack: err instanceof Error ? (err.stack?.split("\n")[0] ?? "") : "",
    };
    console.error("[evaluate-assessments] Unhandled error:", errorPayload);

    return new Response(
      JSON.stringify({ error: "Internal Server Error" }),
      { status: 500, headers: JSON_HEADERS }
    );
  }
});
