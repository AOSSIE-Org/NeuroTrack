import 'dart:math';
import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late List<int> _cards;
  List<int> _flippedIndices = [];
  int _matches = 0;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    List<int> numbers = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6];
    numbers.shuffle(Random());
    _cards = numbers;
    _flippedIndices = List.filled(12, 0);
    _matches = 0;
    _moves = 0;
  }

  void _flipCard(int index) {
    if (_flippedIndices[index] != 0) return;

    setState(() {
      _flippedIndices[index] = 1;
    });

    List<int> currentFlipped = [];
    for (int i = 0; i < _flippedIndices.length; i++) {
      if (_flippedIndices[i] == 1) {
        currentFlipped.add(i);
      }
    }

    if (currentFlipped.length == 2) {
      _moves++;
      int firstIndex = currentFlipped[0];
      int secondIndex = currentFlipped[1];

      if (_cards[firstIndex] == _cards[secondIndex]) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _flippedIndices[firstIndex] = 2;
              _flippedIndices[secondIndex] = 2;
              _matches++;
            });
          }
        });
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _flippedIndices[firstIndex] = 0;
              _flippedIndices[secondIndex] = 0;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isGameComplete = _matches == 6;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Cards'),
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
                _buildStatCard('Moves', _moves.toString()),
                _buildStatCard('Matches', '$_matches/6'),
              ],
            ),
            const SizedBox(height: 30),

            if (isGameComplete)
              Card(
                color: Colors.green.withOpacity(0.2),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.celebration, color: Colors.green),
                      SizedBox(width: 10),
                      Text(
                        'Congratulations! You completed the game!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final isFlipped = _flippedIndices[index] == 1;
                  final isMatched = _flippedIndices[index] == 2;

                  return GestureDetector(
                    onTap: () => _flipCard(index),
                    child: Card(
                      color: isFlipped || isMatched
                          ? AppTheme.primaryColor.withOpacity(0.3)
                          : Colors.grey.shade300,
                      child: Center(
                        child: isFlipped || isMatched
                            ? Text(
                                _cards[index].toString(),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: isMatched ? Colors.green : Colors.black,
                                ),
                              )
                            : const Icon(Icons.help_outline, size: 40),
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
                    _initializeGame();
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

