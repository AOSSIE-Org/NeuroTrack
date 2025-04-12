import 'package:flutter/material.dart';
import '../../gen/assets.gen.dart';
import 'article_screen.dart';

class UpdatesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> latestVideos = [
    {
      'title': 'How to run reports',
      'views': '2.1k views · 5 days ago',
      'thumbnail': Assets.placeholders.thumbnail1,
    },
    {
      'title': 'How to run reports',
      'views': '2.1k views · 5 days ago',
      'thumbnail': Assets.placeholders.thumbnail1,
    }
  ];

  final List<Map<String, dynamic>> latestArticles = [
    {
      'title': 'New feature: Google Meet now has a custom background tool',
      'date': 'Jan 14, 2022',
      'thumbnail': Assets.placeholders.thumbnail1,
    },
    {
      'title': 'New feature: Google Meet now has a custom background tool',
      'date': 'Jan 14, 2022',
      'thumbnail': Assets.placeholders.thumbnail1,
    },
    {
      'title': 'New feature: Google Meet now has a custom background tool',
      'date': 'Jan 14, 2022',
      'thumbnail': Assets.placeholders.thumbnail1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Updates",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'League Spartan'),
              ),
              const SizedBox(height: 24),
              const Text(
                "Latest Videos",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'League Spartan'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 190, // Adjust height based on design
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: latestVideos.length,
                  itemBuilder: (context, index) {
                    final video = latestVideos[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              video['thumbnail']!,
                              width: 200,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            video['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            video['views']!,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Latest Articles",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'League Spartan'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: latestArticles.length,
                  itemBuilder: (context, index) {
                    final article = latestArticles[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ArticleScreen(articleTitle: article['title']!),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                article['thumbnail']!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    article['date']!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
