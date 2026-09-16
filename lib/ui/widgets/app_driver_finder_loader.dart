import 'dart:math';
import 'package:flutter/material.dart';

class AppDriverFindLoader extends StatefulWidget {
  final double size;
  final Color color;

  const AppDriverFindLoader({
    super.key,
    this.size = 60,
    this.color = Colors.blue,
  });

  @override
  State<AppDriverFindLoader> createState() => _AppDriverFindLoaderState();
}

class _AppDriverFindLoaderState extends State<AppDriverFindLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _DotSpinnerPainter(
              rotation: _controller.value,
              dotColor: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _DotSpinnerPainter extends CustomPainter {
  final double rotation;
  final Color dotColor;

  _DotSpinnerPainter({required this.rotation, required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    const dotCount = 8;
    final dotRadius = size.width * 0.06;
    final radius = size.width * 0.4;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < dotCount; i++) {
      final angle = 2 * pi * (i / dotCount) + (2 * pi * rotation);
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);

      // Alpha fade effect for trailing dots
      final alpha = (255 * (i + 1) / dotCount).round();
      final paint = Paint()..color = dotColor.withAlpha(alpha);
      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DotSpinnerPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
