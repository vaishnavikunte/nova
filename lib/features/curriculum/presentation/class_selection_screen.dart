import 'package:flutter/material.dart';
import 'package:majhe_gaon/nova_main/services/app_state.dart';
import 'package:majhe_gaon/nova_main/theme/app_colors.dart';
import 'package:majhe_gaon/nova_main/theme/app_spacing.dart';
import 'package:majhe_gaon/nova_main/theme/app_text_styles.dart';
import 'package:majhe_gaon/nova_main/screens/home/adventure_map_screen.dart';

class ClassSelectionScreen extends StatelessWidget {
  const ClassSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'तुमची इयत्ता निवडा',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'तुम्ही कोणत्या इयत्तेत आहात?',
                style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.lg,
                  crossAxisSpacing: AppSpacing.lg,
                  childAspectRatio: 1.1,
                  children: [
                    _buildClassCard(
                      context,
                      appState,
                      1,
                      'इयत्ता १',
                      Icons.looks_one_rounded,
                      AppColors.purple,
                    ),
                    _buildClassCard(
                      context,
                      appState,
                      2,
                      'इयत्ता २',
                      Icons.looks_two_rounded,
                      AppColors.sky,
                    ),
                    _buildClassCard(
                      context,
                      appState,
                      3,
                      'इयत्ता ३',
                      Icons.looks_3_rounded,
                      AppColors.mint,
                    ),
                    _buildClassCard(
                      context,
                      appState,
                      4,
                      'इयत्ता ४',
                      Icons.looks_4_rounded,
                      AppColors.coral,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context,
    AppState appState,
    int classId,
    String label,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        // Set the class in the global app state
        appState.setClassNumber(classId);

        // Navigate to the map, passing classId as requested
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdventureMapScreen(classId: classId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.5), width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
