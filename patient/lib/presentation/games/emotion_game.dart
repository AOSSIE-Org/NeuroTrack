import 'dart:math';
import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';

class EmotionGame extends StatefulWidget {
  const EmotionGame({super.key});

  @override
  State<EmotionGame> createState() => _EmotionGameState();
}

class _EmotionGameState extends State<EmotionGame> {
  final List<EmotionData> _emotions = [
    EmotionData('Happy', '😊', Colors.yellow),
    EmotionData('Sad', '😢', Colors.blue),
    EmotionData('Angry', '😠', Colors.red),
    EmotionData('Surprised', '😲', Colors.orange),
    EmotionData('Scared', '😨', Colors.purple),
    EmotionData('Calm', '😌', Colors.green),
  ];

  String? _targetEmotion;
  int _score = 0;
  int _round = 0;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _round++;
      _emotions.shuffle(Random());
      _targetEmotion = _emotions[Random().nextInt(_emotions.length)].name;
      _message = 'Find the $_targetEmotion emotion!';
    });
  }

  void _selectEmotion(String emotionName) {
    setState(() {
      if (emotionName == _targetEmotion) {
        _score++;
        _message = 'Correct! Well done! 🎉';
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _nextRound();
          }
        });
      } else {
        _message = 'Not quite. Try again!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Recognition'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Score', _score.toString()),
                _buildStatCard('Round', _round.toString()),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      _message,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    if (_targetEmotion != null)
                      Text(
                        'Find: $_targetEmotion',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _emotions.length,
                itemBuilder: (context, index) {
                  final emotion = _emotions[index];
                  return GestureDetector(
                    onTap: () => _selectEmotion(emotion.name),
                    child: Card(
                      color: emotion.color.withOpacity(0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            emotion.emoji,
                            style: const TextStyle(fontSize: 50),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            emotion.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _score = 0;
                    _round = 0;
                    _nextRound();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Reset Game'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmotionData {
  final String name;
  final String emoji;
  final Color color;

  EmotionData(this.name, this.emoji, this.color);
}

