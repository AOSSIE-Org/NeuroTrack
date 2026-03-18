import 'package:flutter/material.dart';

class LevelIndicator extends StatelessWidget {
  final double currentLevel; // Dynamic value from backend
  final int maxLevel; // Maximum level for slider

  const LevelIndicator({
    super.key,
    required this.currentLevel,
    required this.maxLevel,
  });

  @override
  Widget build(BuildContext context) {
    final safeMaxLevel = maxLevel <= 0 ? 1 : maxLevel;
    final clampedLevel = currentLevel.clamp(0, safeMaxLevel.toDouble());

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
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const indicatorWidth = 40.0;
                      const tickTop = 44.0;
                      const halfIndicator = indicatorWidth / 2;
                      final trackWidth = constraints.maxWidth;
                      final ratio = clampedLevel / safeMaxLevel;
                      final indicatorLeft = ratio * (trackWidth - indicatorWidth);

                      return SizedBox(
                        height: 84,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              top: tickTop,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: halfIndicator),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    safeMaxLevel + 1,
                                    (index) => Container(
                                      height: index % 2 == 0 ? 20 : 15,
                                      width: 2,
                                      color: Colors.white.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: indicatorLeft,
                              top: 0,
                              child: SizedBox(
                                width: indicatorWidth,
                                height: tickTop + 20,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        clampedLevel.toStringAsFixed(0),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: tickTop,
                                      left: 10,
                                      child: CustomPaint(
                                        size: const Size(20, 20),
                                        painter: TrianglePainter(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
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
