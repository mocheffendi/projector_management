import 'package:flutter/material.dart';

/// CustomPageRoute for different forward and reverse durations.
class CustomPageRoute extends PageRouteBuilder {
  final Widget page;
  final Duration forwardDuration;
  final Duration reverseDuration;

  CustomPageRoute({
    required this.page,
    this.forwardDuration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

  @override
  Duration get transitionDuration => forwardDuration;

  @override
  Duration get reverseTransitionDuration => reverseDuration;
}
