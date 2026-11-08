import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

// Card dengan efek neumorphic yang adaptif terhadap tema terang dan gelap.
class NeuCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const NeuCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding ?? const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        boxShadow: [
          // Bayangan gelap (kanan-bawah)
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : colorScheme.shadow.withValues(alpha: 0.15),
            offset: const Offset(8, 8),
            blurRadius: 16,
          ),
          // Bayangan terang (kiri-atas)
          BoxShadow(
            color: isDark
                ? colorScheme.surfaceVariant.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.8),
            offset: const Offset(-8, -8),
            blurRadius: 16,
          ),
        ],
      ),
      child: child,
    );
  }
}
