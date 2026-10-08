import 'package:flutter/material.dart';
import '../../../../nova_main/theme/app_colors.dart';
import '../../../../nova_main/theme/app_text_styles.dart';
import '../../../../nova_main/services/app_state.dart';
import '../../data/lesson_registry.dart';

class LessonPlayerScreen extends StatefulWidget {
  final int standard;
  final int level;

  const LessonPlayerScreen({
    super.key,
    required this.standard,
    required this.level,
  });

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final lesson = LessonRegistry.getLesson(widget.standard, widget.level);
    
    if (lesson == null) {
      return const Scaffold(
        body: Center(child: Text("Lesson not found!")),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Handle cleanup here if needed
      },
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            lesson.title,
            style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Text(
            "Std ${widget.standard} Level ${widget.level} Skeleton",
            style: AppTextStyles.headingMedium,
          ),
        ),
      ),
    );
  }
}
