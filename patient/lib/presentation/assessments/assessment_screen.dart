import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/provider/assessment_provider.dart';
import 'package:provider/provider.dart';
import 'package:patient/presentation/result/result.dart';


class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  AssessmentScreenState createState() => AssessmentScreenState();
}

class AssessmentScreenState extends State<AssessmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssessmentProvider>(context, listen: false)
          .fetchAssessmentBySelectedId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AssessmentProvider>(
          builder: (context, provider, child) {
            if (provider.assessment == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.secondaryColor,
                ),
              );
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "Autism Quotient (AQ)",
                    style: TextStyle(
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
                        itemCount:
                            (provider.assessment!['questions'] as List).length,
                        itemBuilder: (context, index) {
                          final question =
                              provider.assessment!['questions'][index];
                          return QuestionCard(
                            question: question,
                            questionIndex: index,
                            onAnswerSelected: (value) {
                              provider.selectAnswer(index, value);
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
                          final assessmentProvider =
                              Provider.of<AssessmentProvider>(context,
                                  listen: false);
                          final selectedAnswers =
                              assessmentProvider.selectedAnswers;
                          final questionsList = provider.assessment!['questions'] as List ;
                              

                          final List<Map<String, String>> responses = [];
                          for (int i = 0; i < questionsList.length; i++) {
                            responses.add({
                              'question': questionsList[i]['text'] as String,
                              'answer': selectedAnswers[i] ?? '', // Handle cases where no answer is selected
                            });
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultScreen(
                                  responses: responses,patientId: "550e8400-e29b-41d4-a716-446655440001"),
                            ),
                          );
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
  final Map<String, dynamic> question;
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
    final provider = Provider.of<AssessmentProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question['text'] as String, // Displaying the question text
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          ...List<Map<String, dynamic>>.from(question['options']).map((option) {
            final optionText = option['text'] as String;
            final isSelected =
                provider.selectedAnswers[questionIndex] == optionText;

            return GestureDetector(
              onTap: () {
                onAnswerSelected(optionText);
              },
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      onAnswerSelected(value == true ? optionText : '');
                    },
                    activeColor: AppTheme.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    side: const BorderSide(
                      color: Color(0xFF666666),
                      width: 1.5,
                    ),
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