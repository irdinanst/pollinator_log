import 'dart:ui';
import 'package:flutter/material.dart';

class GlowBackground extends StatelessWidget {
  const GlowBackground({super.key, required this.child});

  final Widget child; // the screen content, drawn on top of the glows

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Honey glow, top right
        Positioned(
          top: -80,
          right: -110,
          child: _glow(scheme.secondary.withValues(alpha: 0.45), 300),
        ),
        // Green glow, middle left
        Positioned(
          top: 380,
          left: -150,
          child: _glow(scheme.primary.withValues(alpha: 0.25), 320),
        ),
        // The real screen content, on top of the glows
        Positioned.fill(child: child),
      ],
    );
  }

  // A blurred circle = a soft glow
  Widget _glow(Color color, double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}