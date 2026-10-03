import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/haptics_service.dart';
import '../theme/app_colors.dart';
import 'demo_controls.dart';

/// Draggable floating "🛠 Demo" button overlay available on all screens for evaluators.
class DemoFab extends StatefulWidget {
  const DemoFab({super.key});

  @override
  State<DemoFab> createState() => _DemoFabState();
}

class _DemoFabState extends State<DemoFab> {
  Offset _position = const Offset(16, 580);

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    if (!appState.showDemoFab) return const SizedBox.shrink();

    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      left: _position.dx.clamp(8.0, screenSize.width - 90.0),
      top: _position.dy.clamp(60.0, screenSize.height - 90.0),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        child: Material(
          elevation: 6,
          shape: const StadiumBorder(),
          color: AppColors.navy.withValues(alpha: 0.90),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () {
              HapticsService.lightImpact();
              DemoControlsSheet.show(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.build_circle_rounded, color: AppColors.sunYellow, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Demo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
