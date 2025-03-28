import 'package:flutter/material.dart';
import 'package:patient/core/core.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/model/assessment_models/assessment_models.dart';
import 'package:patient/presentation/widgets/snackbar_service.dart';
import 'package:patient/provider/assessment_provider.dart';
import 'package:provider/provider.dart';
import 'package:patient/presentation/result/result.dart';


class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({
    super.key,
    required this.assessment,
  });

  final AssessmentModel assessment;

  @override
  AssessmentScreenState createState() => AssessmentScreenState();
}

class AssessmentScreenState extends State<AssessmentScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final assessmentProvider = context.read<AssessmentProvider>();
      if (assessmentProvider.submitAssessmentStatus.isSuccess) {
        SnackbarService.showSuccess(
            '${assessmentProvider.assessmentResultModel?.message}');
      } else if (assessmentProvider.submitAssessmentStatus.isFailure) {
        SnackbarService.showError(
            'Something went wrong. Please try again later.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AssessmentProvider>(context, listen: true)
        .submitAssessmentStatus;
    return Scaffold(
      body: SafeArea(
        child: Consumer<AssessmentProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    widget.assessment.name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tell us a bit about yourself',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ListView.builder(
                        itemCount: widget.assessment.questions.length,
                        itemBuilder: (context, index) {
                          final question = widget.assessment.questions[index];
                          return QuestionCard(
                            question: question,
                            questionIndex: index,
                            onAnswerSelected: (String optionId) {
                              context
                                      .read<AssessmentProvider>()
                                      .assessmentAnswers =
                                  AssessmentQuestionAnswerModel(
                                questionId: question.questionId,
                                answerId: optionId,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {

                          context.read<AssessmentProvider>().submitAssessment();

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2, // Small shadow effect
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Submit Assessment',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final AssessmentQuestionModel question;
  final int questionIndex;
  final ValueChanged<String> onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          question.text,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ...question.options.map((option) {
          final assessmentAnswers =
              context.read<AssessmentProvider>().assessmentAnswerModel;
          final optionText = option.text;
          final isSelected = assessmentAnswers?.questions.any((element) =>
                  element.questionId == question.questionId &&
                  element.answerId == option.optionId) ??
              false;
          return SizedBox(
            height: 30,
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    if (value == true) {
                      onAnswerSelected(option.optionId);
                    } else {
                      onAnswerSelected('');
                    }
                  },
                  activeColor: AppTheme.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  side: const BorderSide(
                    color: Color(0xFF666666),
                    width: 1.5,

                  ),
                  Expanded(
                    child: Text(
                      optionText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.subtitleColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}