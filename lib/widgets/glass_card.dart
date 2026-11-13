import 'dart:ui'; // gives us ImageFilter (the blur)
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final Widget child;                 // what goes inside the card
  final EdgeInsetsGeometry padding;   // space inside the card
  final BorderRadius borderRadius;    // corner shape (can change per card)

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    // A. Outer Container: only the soft shadow
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.10),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // B. ClipRRect: keeps the blur INSIDE the rounded corners
      child: ClipRRect(
        borderRadius: borderRadius,
        // C. BackdropFilter: blurs whatever is BEHIND the card
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          // D. Inner Container: see-through white + thin white border
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: borderRadius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}