import 'package:flutter/material.dart';
import 'package:patient/presentation/home/home_screen_slider.dart';

class HomeContent extends StatelessWidget {
  final String userName;

  const HomeContent({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(92, 93, 103, 1),
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 2, 2, 2),
                      fontFamily: 'League Spartans',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Autism Level Card
                  const LevelIndicator(
                    currentLevel: 5, // Dynamic value
                    maxLevel: 18,
                  ),

                  const SizedBox(height: 7),

                  // Therapy Goals Card
                  _buildCard(
                    title1: "Therapy",
                    title2: "Goals",
                    imagePath: 'assets/illustration1.png',
                    backgroundColor: const Color(0xFFF9F3E3),
                  ),

                  const SizedBox(height: 7),

                  // Daily Activities Card
                  _buildCard(
                    title1: "Daily",
                    title2: "Activities",
                    imagePath: 'assets/illustration.png',
                    backgroundColor: const Color(0xFFFEF4F0),
                    imageOnLeft: true,
                  ),

                  const SizedBox(height: 7),

                  // Development Milestones Card
                  _buildCard(
                    title1: "Development",
                    title2: "Milestones",
                    imagePath: 'assets/illustration2.png',
                    backgroundColor: const Color(0xFFF5FAF4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title1,
    required String title2,
    required String imagePath,
    required Color backgroundColor,
    bool imageOnLeft = false,
  }) {
    return Card(
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Row(
          
          children: [
            if (imageOnLeft)
              Image.asset(imagePath, height: 100, width: 120, fit: BoxFit.contain),
            if (imageOnLeft) const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // crossAxisAlignment: imageOnLeft
              //     ? CrossAxisAlignment.end
              //     : CrossAxisAlignment.start,
              children: [
                Text(
                  title1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold ,
                    color: Colors.black,
                    fontFamily: 'League Spartan',
                  ),
                ),
                Text(
                  title2,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'League Spartan',
                  ),
                ),
              ],
            ),
            if (!imageOnLeft) const Spacer(),
            if (!imageOnLeft)
              Image.asset(imagePath, height: 90, width: 120, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}
