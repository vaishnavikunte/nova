import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../demo/demo_fab.dart';
import '../../services/haptics_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../progress/profile_journey_screen.dart';
import '../progress/progress_screen.dart';
import 'adventure_map_screen.dart';
import '../../services/app_state.dart';
import '../../widgets/mascot_widget.dart';
import '../../routes/app_routes.dart';
import '../accessibility/accessibility_settings_screen.dart';
import '../onboarding/student_setup_screen.dart';

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
        title: Text(
          AppStrings.leaveNovaTitle,
          style: AppTextStyles.questionText,
        ),
        content: const Text(
          'Do you want to leave your adventure? Your stars and badges are safe!',
          style: TextStyle(fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              AppStrings.stayButton,
              style: AppTextStyles.buttonSecondary,
            ),
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

  void _logOut(BuildContext context) {
    // Clear student name and session info, keeping progress and theme
    AppStateScope.of(context).clearStudentSession();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const StudentSetupScreen()),
      (route) => false,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final appState = AppStateScope.of(context);
    final studentName = appState.student.name;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 30,
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(32)),
            ),
            child: Row(
              children: [
                const MascotWidget(size: 80, mood: NovaMood.happy),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'नमस्कार,',
                        style: TextStyle(
                          color: Color(0xFFB9A0FF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        studentName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(
              Icons.home_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            title: Text(
              'Home (मुख्यपृष्ठ)',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _onTabTapped(0);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            title: Text(
              'Settings (सेटिंग्ज)',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccessibilitySettingsScreen()),
              );
            },
          ),
          const Spacer(),
          const Divider(color: Color(0xFFB9A0FF), thickness: 2),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Color(0xFFFF8A7A),
              size: 32,
            ),
            title: const Text(
              'Log Out (बाहेर पडा)',
              style: TextStyle(
                color: Color(0xFFFF8A7A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => _logOut(context),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
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
        backgroundColor: Colors.transparent,
        drawer: _buildDrawer(context),
        body: Stack(
          children: [
            IndexedStack(index: _currentIndex, children: tabs),
            const DemoFab(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: const Border(
              top: BorderSide(color: AppColors.borderLight, width: 1.5),
            ),
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
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
            height: 72,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.map_outlined, color: AppColors.inkSoft),
                selectedIcon: Icon(
                  Icons.map_rounded,
                  color: AppColors.indigo,
                  size: 28,
                ),
                label: AppStrings.navAdventure,
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.star_outline_rounded,
                  color: AppColors.inkSoft,
                ),
                selectedIcon: Icon(
                  Icons.star_rounded,
                  color: AppColors.sunYellow,
                  size: 28,
                ),
                label: AppStrings.navProgress,
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.sentiment_satisfied_alt_outlined,
                  color: AppColors.inkSoft,
                ),
                selectedIcon: Icon(
                  Icons.sentiment_satisfied_alt_rounded,
                  color: AppColors.purple,
                  size: 28,
                ),
                label: AppStrings.navMe,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
