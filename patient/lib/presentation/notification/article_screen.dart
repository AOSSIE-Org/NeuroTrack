import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class ArticleScreen extends StatelessWidget {
  final String articleTitle;

  const ArticleScreen({super.key, required this.articleTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Artical", // Changed to match the image
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'League Spartan',
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 240, 237, 237),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Title
            Text(
              "Learn About Heartbeat.", // Use bold title
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'League Spartan',
              ),
            ),
            const SizedBox(height: 10),

            // Article Content
            const Text(
              "A heartbeat is a two-part pumping action that takes about a second. "
              "As blood collects in the upper chambers (the right and left atria), "
              "the heart’s natural pacemaker (the SA node) sends out an electrical signal "
              "that causes the atria to contract.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Card-like Playable Section

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
              decoration: BoxDecoration(
                color: const Color(0xFFE4E7F9), // Light grey background
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Row(
                children: [
                  // Left side: Text + Play Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Learn About Heartbeat.",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            // Play Icon
                            SizedBox(width: 2),
                            const Icon(Icons.play_circle_outline,
                                color: Color.fromRGBO(122, 134, 248, 1),
                                size: 30),

                            const SizedBox(width: 6),

                            // "Check Now" Text
                            const Text(
                              "Check Now",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color.fromRGBO(122, 134, 248, 1)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Right side: Illustration Image
                  Assets.illustrations.i9nHeartbeat.svg(
                    width: 90, // Adjusted size to match design
                    height: 90,
                    fit: BoxFit.contain,
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Additional Content
            const Text(
              "Your pulse is measured by counting the number of times your heart beats in one minute. "
              "For example, if your heart contracts 72 times in one minute, your pulse would be 72 beats per minute (BPM). "
              "This is also called your heart rate. A normal pulse beats in a steady, regular rhythm.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            const Text(
              "This is also called your heart rate. A normal pulse beats in a steady, regular rhythm.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
