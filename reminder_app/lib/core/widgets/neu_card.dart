import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class NeuCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const NeuCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        boxShadow: [
          const BoxShadow(
            color: Color(0xFF122424), // Bayangan gelap (kanan-bawah)
            offset: Offset(8, 8),
            blurRadius: 16,
          ),
          BoxShadow(
            color: AppColors.surfaceLight, // Bayangan terang (kiri-atas)
            offset: const Offset(-8, -8),
            blurRadius: 16,
          ),
        ],
      ),
      child: child,
    );
  }
}