import 'package:flutter/material.dart';

class LevelIndicator extends StatelessWidget {
  final double currentLevel; // Dynamic value from backend
  final int maxLevel; // Maximum level for slider

  const LevelIndicator({
    Key? key,
    required this.currentLevel,
    required this.maxLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFCB6CE6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Autism Level',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Slider track
                      Container(
                        height: 40, // Increased height for better visibility
                        decoration: BoxDecoration(
                          color: const Color(0xFFCB6CE6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // Tick marks
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          maxLevel, // Number of divisions based on max level
                          (index) => Container(
                            height: index % 2 == 0
                                ? 20
                                : 15, // Alternating heights for ticks
                            width: 2,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      // Current level indicator (triangle)
                      // Current level indicator (triangle with text above)
                      Positioned(
                        left: (currentLevel / (maxLevel)) *
                            (MediaQuery.of(context).size.width * 0.8 -
                                25), // Adjust for better alignment
                        child: Column(
                          children: [
                            Text(
                              currentLevel.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CustomPaint(
                              size: const Size(20, 20),
                              painter: TrianglePainter(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for triangle thumb indicator
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;
    Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
