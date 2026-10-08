import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/haptics_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Interactive speech bubble with typewriter reveal, tail pointer, and audio replay.
class SpeechBubble extends StatefulWidget {
  final String text;
  final String? speaker;
  final bool typewriter;
  final VoidCallback? onComplete;
  final VoidCallback? onReplay;

  const SpeechBubble({
    super.key,
    required this.text,
    this.speaker,
    this.typewriter = true,
    this.onComplete,
    this.onReplay,
  });

  @override
  State<SpeechBubble> createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<SpeechBubble> {
  int _displayedLength = 0;
  Timer? _typewriterTimer;

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  @override
  void didUpdateWidget(covariant SpeechBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _startTypewriter();
    }
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    super.dispose();
  }

  void _startTypewriter() {
    _typewriterTimer?.cancel();
    if (!widget.typewriter) {
      setState(() {
        _displayedLength = widget.text.length;
      });
      widget.onComplete?.call();
      return;
    }

    _displayedLength = 0;
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 32), (timer) {
      if (_displayedLength < widget.text.length) {
        setState(() {
          _displayedLength++;
        });
      } else {
        timer.cancel();
        widget.onComplete?.call();
      }
    });
  }

  Future<void> _playTts() async {
    final flutterTts = FlutterTts();
    await flutterTts.setLanguage("mr-IN");
    await flutterTts.speak(widget.text);
  }

  void _skipTypewriter() {
    if (_displayedLength < widget.text.length) {
      _typewriterTimer?.cancel();
      setState(() {
        _displayedLength = widget.text.length;
      });
      widget.onComplete?.call();
      HapticsService.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentText = widget.text.substring(0, _displayedLength);

    return GestureDetector(
      onTap: _skipTypewriter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppSpacing.roundedCard,
              border: Border.all(color: AppColors.borderLight, width: 2.0),
              boxShadow: AppSpacing.softShadow,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.speaker != null) ...[
                        Text(
                          widget.speaker!,
                          style: AppTextStyles.chip.copyWith(color: AppColors.purple),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                      ],
                      Text(
                        currentText,
                        style: AppTextStyles.storyNarration,
                      ),
                    ],
                  ),
                ),
                if (widget.onReplay != null || true) // Always show speaker if we can play TTS
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.indigo, size: 26),
                    onPressed: () {
                      _startTypewriter();
                      _playTts(); // Play TTS!
                      widget.onReplay?.call();
                      HapticsService.selectionClick();
                    },
                    tooltip: 'Read again',
                  ),
              ],
            ),
          ),
          // Downward pointer tail pointing to NOVA
          Positioned(
            left: 28,
            bottom: -9,
            child: CustomPaint(
              size: const Size(18, 10),
              painter: _BubbleTailPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.borderLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
