import { createClient } from "@supabase/supabase-js";
import { 
  AssessmentDTO,
  QuestionDTO,
  OptionDTO,
  AssessmentEvaluationRequestDTO,
  AssessmentEvaluationQuestionDTO,
} from "./dto/types.ts";
const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_ANON_KEY")!);
/**
 * Supabase Edge Function to evaluate an autism assessment.
 * 
 * This function:
 * 1. Receives a request containing `assessment_id` and `questions` (answered by the user).
 * 2. Fetches the assessment data from the `assessments` table in Supabase.
 * 3. Calculates the total score based on the user's answers.
 * 4. Compares the total score with the assessment's cutoff score.
 * 5. Returns a JSON response indicating whether the user is likely autistic.
 * 
 * @param {Request} req - The HTTP request object containing JSON payload.
 * @returns {Response} - A JSON response with the assessment results.
 */
Deno.serve( async (req) => {
  try {
    const body = await req.json().catch(() => null);
    if (
      !body ||
      !body.patient_id ||
      !body.assessment_id ||
      !Array.isArray(body.questions) ||
      body.questions.length === 0
    ) {
      return new Response(
        JSON.stringify({ error: "Missing or invalid request body. Required fields: patient_id, assessment_id, questions (non-empty array)." }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }
    const { patient_id, assessment_id, questions } = body;
    const { data, error } = await supabase
      .from("assessments")
      .select("*")
      .eq("id", assessment_id)
      .single();
      if(error) {
        return new Response(JSON.stringify({ error: "Internal Server Error" }), { status: 500 });
      }
      if (!data) {
        return new Response(JSON.stringify({ error: "Assessment not found" }), { status: 404 });
      }
      const answered_questions: AssessmentEvaluationRequestDTO = {
        assessment_id: assessment_id,
        questions: questions.map((q: AssessmentEvaluationQuestionDTO) => ({
          question_id: q.question_id,
          answer_id: q.answer_id,
        }))
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
      let scoredCount = 0;
      for(let i=0;i<answered_questions.questions.length;i++) {
        const question = answered_questions.questions[i];
        const matched_question = assessment.questions.find(q => q.question_id === question.question_id);
        if(!matched_question) {
          continue;
        }
        const answer = matched_question.options.find(o => o.option_id === question.answer_id);
        if(!answer) {
          continue;
        }
        totalScore += answer.score;
        scoredCount++;
      }
      if (scoredCount === 0) {
        return new Response(
          JSON.stringify({ error: "No questions could be scored. Check that question_id and answer_id values match the assessment." }),
          { status: 422, headers: { "Content-Type": "application/json" } }
        );
      }
      const isAutistic = totalScore >= assessment.cutoff_score;
      
      const responseData = {
        assessment_score: totalScore,
        is_autistic: isAutistic,
        message: isAutistic
          ? "The assessment indicates a likelihood of autism. Further evaluation is recommended."
          : "The assessment does not indicate autism, but professional consultation is advised if needed.",
      };
      await supabase.from('assessment_results')
            .insert({
              'assessment_id': assessment_id,
              'submission': answered_questions,
              'patient_id': patient_id,
              'result': responseData,
            });
      return new Response(
        JSON.stringify(responseData),{
          headers: { "Content-Type": "application/json" },
          status: 200,
        },
      );
  } catch (error) {
    return new Response(JSON.stringify({ error: "Internal Server Error" }), { status: 500 });
  }
})
