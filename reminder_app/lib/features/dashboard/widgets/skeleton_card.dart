import 'package:flutter/material.dart';

// Widget placeholder berdenyut saat data sedang dimuat.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Container(
          height: 160,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withValues(alpha: value),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}