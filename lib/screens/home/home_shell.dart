import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../demo/demo_fab.dart';
import '../../services/haptics_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../progress/profile_journey_screen.dart';
import '../progress/progress_screen.dart';
import 'adventure_map_screen.dart';

/// Main navigation shell hosting Adventure Map, Progress, and Profile tabs with friendly exit guard.
class HomeShell extends StatefulWidget {
  final int initialTab;

  const HomeShell({super.key, this.initialTab = 0});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      HapticsService.selectionClick();
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }

    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(AppStrings.leaveNovaTitle, style: AppTextStyles.questionText),
        content: const Text(
          'Do you want to leave your adventure? Your stars and badges are safe!',
          style: TextStyle(fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppStrings.stayButton, style: AppTextStyles.buttonSecondary),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.coral),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppStrings.leaveButton, style: AppTextStyles.button),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      const AdventureMapScreen(),
      ProgressScreen(onContinueToMap: () => _onTabTapped(0)),
      const ProfileJourneyScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _onWillPop();
        if (shouldExit && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: tabs,
            ),
            const DemoFab(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.borderLight, width: 1.5)),
            boxShadow: [
              BoxShadow(
                color: Color(0x0D1F2A6B),
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTabTapped,
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFEEF2FF),
            height: 72,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.map_outlined, color: AppColors.inkSoft),
                selectedIcon: Icon(Icons.map_rounded, color: AppColors.indigo, size: 28),
                label: AppStrings.navAdventure,
              ),
              NavigationDestination(
                icon: Icon(Icons.star_outline_rounded, color: AppColors.inkSoft),
                selectedIcon: Icon(Icons.star_rounded, color: AppColors.sunYellow, size: 28),
                label: AppStrings.navProgress,
              ),
              NavigationDestination(
                icon: Icon(Icons.sentiment_satisfied_alt_outlined, color: AppColors.inkSoft),
                selectedIcon: Icon(Icons.sentiment_satisfied_alt_rounded, color: AppColors.purple, size: 28),
                label: AppStrings.navMe,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
