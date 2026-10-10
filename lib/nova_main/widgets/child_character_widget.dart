import 'dart:math';
import 'package:flutter/material.dart';

enum ChildProp { rocket, testTube, book, none }

/// A reusable animated child character using CustomPainter for the purple STEM theme.
class ChildCharacterWidget extends StatefulWidget {
  final double size;
  final ChildProp prop;
  final bool animate;

  const ChildCharacterWidget({
    super.key,
    this.size = 120.0,
    this.prop = ChildProp.none,
    this.animate = true,
  });

  @override
  State<ChildCharacterWidget> createState() => _ChildCharacterWidgetState();
}

class _ChildCharacterWidgetState extends State<ChildCharacterWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.animate) _floatController.repeat(reverse: true);

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    if (widget.animate) _blinkController.repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _blinkController]),
      builder: (context, child) {
        final floatY = widget.animate
            ? sin(_floatController.value * pi * 2) * 4.0
            : 0.0;
        final blinkVal = _blinkController.value;
        final eyeOpenFactor = (blinkVal > 0.95)
            ? (1.0 - (blinkVal - 0.95) / 0.05).clamp(0.0, 1.0)
            : 1.0;

        return Transform.translate(
          offset: Offset(0, floatY),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _ChildPainter(
                eyeOpenFactor: eyeOpenFactor,
                prop: widget.prop,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChildPainter extends CustomPainter {
  final double eyeOpenFactor;
  final ChildProp prop;

  _ChildPainter({required this.eyeOpenFactor, required this.prop});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final headRadius = size.width * 0.35;

    // Body
    final bodyPaint = Paint()
      ..color = const Color(0xFFFF8FCB); // Bubblegum pink shirt
    final bodyRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + headRadius + 10),
      width: headRadius * 1.5,
      height: headRadius * 1.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(headRadius * 0.5)),
      bodyPaint,
    );

    // Head (Skin)
    final skinPaint = Paint()..color = const Color(0xFFFFCCAA);
    canvas.drawCircle(Offset(center.dx, center.dy - 10), headRadius, skinPaint);

    // Hair
    final hairPaint = Paint()..color = const Color(0xFF4A2B12);
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(center.dx, center.dy - 15),
        radius: headRadius * 1.05,
      ),
      pi,
      pi,
      true,
      hairPaint,
    );
    canvas.drawCircle(
      Offset(center.dx - headRadius * 0.8, center.dy - headRadius * 0.5),
      headRadius * 0.4,
      hairPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + headRadius * 0.8, center.dy - headRadius * 0.5),
      headRadius * 0.4,
      hairPaint,
    );

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF2F185E);
    final eyeY = center.dy - 10;
    final eyeXOffset = headRadius * 0.4;
    final eyeRadius = headRadius * 0.15;

    if (eyeOpenFactor > 0.1) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx - eyeXOffset, eyeY),
          width: eyeRadius * 2,
          height: eyeRadius * 2 * eyeOpenFactor,
        ),
        eyePaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx + eyeXOffset, eyeY),
          width: eyeRadius * 2,
          height: eyeRadius * 2 * eyeOpenFactor,
        ),
        eyePaint,
      );
    } else {
      final linePaint = Paint()
        ..color = const Color(0xFF2F185E)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(center.dx - eyeXOffset - eyeRadius, eyeY),
        Offset(center.dx - eyeXOffset + eyeRadius, eyeY),
        linePaint,
      );
      canvas.drawLine(
        Offset(center.dx + eyeXOffset - eyeRadius, eyeY),
        Offset(center.dx + eyeXOffset + eyeRadius, eyeY),
        linePaint,
      );
    }

    // Cheeks
    final cheekPaint = Paint()
      ..color = const Color(0xFFFF8A7A).withValues(alpha: 0.4);
    canvas.drawCircle(
      Offset(center.dx - eyeXOffset * 1.3, eyeY + eyeRadius * 1.5),
      eyeRadius * 0.8,
      cheekPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + eyeXOffset * 1.3, eyeY + eyeRadius * 1.5),
      eyeRadius * 0.8,
      cheekPaint,
    );

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF2F185E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, eyeY + eyeRadius),
        width: eyeRadius * 2,
        height: eyeRadius * 1.5,
      ),
      0,
      pi,
      false,
      smilePaint,
    );

    // Prop
    if (prop != ChildProp.none) {
      final propCenter = Offset(center.dx + headRadius, center.dy + headRadius);
      if (prop == ChildProp.testTube) {
        final tubePaint = Paint()..color = const Color(0x8878C9FF);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: propCenter, width: 15, height: 40),
            const Radius.circular(7),
          ),
          tubePaint,
        );
        final liquidPaint = Paint()..color = const Color(0xFF72E5BD);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(propCenter.dx, propCenter.dy + 5),
              width: 15,
              height: 30,
            ),
            const Radius.circular(7),
          ),
          liquidPaint,
        );
      } else if (prop == ChildProp.rocket) {
        final rocketPaint = Paint()..color = const Color(0xFF7041D9);
        final path = Path()
          ..moveTo(propCenter.dx, propCenter.dy - 20)
          ..lineTo(propCenter.dx - 10, propCenter.dy + 15)
          ..lineTo(propCenter.dx + 10, propCenter.dy + 15)
          ..close();
        canvas.drawPath(path, rocketPaint);
        canvas.drawCircle(propCenter, 4, Paint()..color = Colors.white);
      } else if (prop == ChildProp.book) {
        final bookPaint = Paint()..color = const Color(0xFF5425A8);
        canvas.drawRect(
          Rect.fromCenter(center: propCenter, width: 25, height: 35),
          bookPaint,
        );
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(propCenter.dx - 5, propCenter.dy),
            width: 10,
            height: 30,
          ),
          Paint()..color = Colors.white,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ChildPainter oldDelegate) =>
      oldDelegate.eyeOpenFactor != eyeOpenFactor || oldDelegate.prop != prop;
}
