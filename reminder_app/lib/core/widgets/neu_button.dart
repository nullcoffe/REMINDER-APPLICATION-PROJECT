import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

// Tombol utama dengan efek shadow dan animasi tap.
class NeuButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const NeuButton({super.key, required this.text, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
        child: Container(
          padding: AppSizes.buttonPadding,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.5),
                offset: const Offset(4, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: colorScheme.onPrimary),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.fontSizeMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
