import { createClient } from "@supabase/supabase-js";

import {
  AssessmentDTO,
  QuestionDTO,
  OptionDTO,
  AssessmentEvaluationRequestDTO,
  AssessmentEvaluationQuestionDTO,
} from "./dto/types.ts";

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
        { status: 401 }
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
        { status: 401 }
      );
    }

    const { assessment_id, questions } = await req.json();

    const patient_id = user.id;

    const { data, error } = await supabase
      .from("assessments")
      .select("*")
      .eq("id", assessment_id)
      .single();

    if (error) {
      return new Response(
        JSON.stringify({ error: "Internal Server Error" }),
        { status: 500 }
      );
    }

    if (!data) {
      return new Response(
        JSON.stringify({ error: "Assessment not found" }),
        { status: 404 }
      );
    }

    const answered_questions: AssessmentEvaluationRequestDTO = {
      assessment_id: assessment_id,
      questions: questions.map((q: AssessmentEvaluationQuestionDTO) => ({
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

    for (let i = 0; i < answered_questions.questions.length; i++) {
      const question = answered_questions.questions[i];
      const matched_question = assessment.questions.find(
        (q) => q.question_id === question.question_id
      );

      if (!matched_question) {
        continue;
      }

      const answer = matched_question.options.find(
        (o) => o.option_id === question.answer_id
      );

      if (!answer) {
        continue;
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
      .insert({
        assessment_id: assessment_id,
        submission: answered_questions,
        patient_id: patient_id,
        result: responseData,
      });

    if (insertError) {
      return new Response(
        JSON.stringify({ error: "Failed to save assessment result" }),
        { status: 500 }
      );
    }

    return new Response(JSON.stringify(responseData), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  } catch (error) {
    return new Response(
      JSON.stringify({ error: "Internal Server Error" }),
      { status: 500 }
    );
  }
});
