import 'package:flutter/material.dart';

/// Custom page transitions honoring the Reduce Motion accessibility setting.
class RouteTransitions {
  RouteTransitions._();

  static Route<T> slideUp<T>(Widget page, {bool reduceMotion = false}) {
    if (reduceMotion) {
      return MaterialPageRoute<T>(builder: (_) => page);
    }
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Route<T> horizontalSlide<T>(Widget page, {bool reduceMotion = false}) {
    if (reduceMotion) {
      return MaterialPageRoute<T>(builder: (_) => page);
    }
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 280),
    );
  }

  static Route<T> scaleFade<T>(Widget page, {bool reduceMotion = false}) {
    if (reduceMotion) {
      return MaterialPageRoute<T>(builder: (_) => page);
    }
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.90, end: 1.0).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 320),
    );
  }
}
