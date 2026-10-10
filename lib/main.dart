import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'nova_main/theme/app_theme.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/curriculum/presentation/village_dashboard_screen.dart';
import 'core/routing/boot_logic.dart';
import 'nova_main/services/app_state.dart';
import 'nova_main/screens/onboarding/welcome_screen.dart';
import 'nova_main/widgets/global_purple_theme.dart';

void main() {
  final appState = AppState();
  runApp(
    ProviderScope(
      child: AppStateScope(appState: appState, child: const MajheGaonApp()),
    ),
  );
}

class MajheGaonApp extends StatelessWidget {
  const MajheGaonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = appState.accessibility.isDarkMode;

    return MaterialApp(
      title: 'Majhe Gaon',
      theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: const BootRouter(),
      builder: (context, child) {
        return GlobalPurpleThemeWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
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
          return const WelcomeScreen();
        } else {
          return const OnboardingScreen();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Error loading database: $err'))),
    );
  }
}
