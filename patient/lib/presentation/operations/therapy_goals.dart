import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../../gen/assets.gen.dart';

class TherapyGoalsScreen extends StatefulWidget {
  const TherapyGoalsScreen({super.key});

  @override
  TherapyGoalsScreenState createState() => TherapyGoalsScreenState();
}

class TherapyGoalsScreenState extends State<TherapyGoalsScreen> {
  int selectedTabIndex =
      0; // 0 for Goals, 1 for Achievements, 2 for Observations
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Refactor this code to use existing provider `allAssessment` instead of fetching data again
    // Future.microtask(() {
    //   Provider.of<AssessmentProvider>(context, listen: false)
    //       .fetchAssessmentBySelectedId();
    // });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Therapy Goals"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker Bar
            EasyDateTimeLinePicker.itemBuilder(
              firstDate: DateTime(2025, 3, 1),
              lastDate: DateTime(2025, 4, 1),
              focusedDate: selectedDate,
              itemExtent: screenWidth * 0.2,
              itemBuilder:
                  (context, date, isSelected, isDisabled, isToday, onTap) {
                return GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: 20,
                    width: isToday ? screenWidth * 0.25 : screenWidth * 0.2,
                    child: Container(
                      constraints:
                          const BoxConstraints(minHeight: 30, maxHeight: 40),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF7A86F8) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        isToday ? "Today" : "${date.day}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
              onDateChange: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),

            const SizedBox(height: 20),

            // Therapy Card
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: const Color.fromARGB(82, 158, 158, 158)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            Assets.placeholders.therapistImg.provider(),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Therapist Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Text(
                            "Neurologist",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn("Therapy", "Therapy Name"),
                      _buildInfoColumn("Done at", "05:30 PM"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn("Therapy Mode", "Offline"),
                      _buildInfoColumn("Duration", "1 hour 20 mins"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Tab Selection
            Container(
              padding: const EdgeInsets.all(6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(250, 250, 250, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabButton("Goals", 0),
                  _buildTabButton("Achievements", 1),
                  _buildTabButton("Observations", 2),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Content Display
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(250, 250, 250, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildContent(selectedTabIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          color: selectedTabIndex == index
              ? const Color(0xFF7A86F8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: selectedTabIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black)),
      ],
    );
  }

  Widget _buildContent(int index) {
    // final assessmentProvider = Provider.of<AssessmentProvider>(context);
    const assessment = null; //assessmentProvider.assessment;

    if (assessment == null || !assessment.containsKey('questions')) {
      return Center(
        child: Text(
          "No Data Available",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      );
    }

    List<String> goals = assessment['questions']
        .map<String>((q) => q['question'] as String)
        .toList();

    List<String> achievements = assessment['questions']
        .map<String>((q) => "Achieved: ${q['question']}")
        .toList();

    List<String> observations = assessment['questions']
        .map<String>((q) => "Observed: ${q['question']}")
        .toList();

    List<String> data =
        index == 0 ? goals : (index == 1 ? achievements : observations);

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "${i + 1}. ${data[i]}",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
        );
      },
    );
  }
}
