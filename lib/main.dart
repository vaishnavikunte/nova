import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/curriculum/presentation/village_dashboard_screen.dart';
import 'core/routing/boot_logic.dart';
void main() {
  runApp(
    const ProviderScope(
      child: MajheGaonApp(),
    ),
  );
}

class MajheGaonApp extends StatelessWidget {
  const MajheGaonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majhe Gaon',
      theme: AppTheme.lightTheme,
      home: const BootRouter(),
    );
  }
}

class BootRouter extends ConsumerWidget {
  const BootRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootState = ref.watch(bootLogicProvider);

    return bootState.when(
      data: (hasProfiles) {
        if (hasProfiles) {
          return const VillageDashboardScreen();
        } else {
          return const OnboardingScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Text('Error loading database: $err'),
        ),
      ),
    );
  }
}
