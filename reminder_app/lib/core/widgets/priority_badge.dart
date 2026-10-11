import 'package:flutter/material.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;

  const PriorityBadge({
    Key? key,
    required this.priority,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String label = priority.toUpperCase();

    // Menentukan warna berdasarkan tingkat prioritas
    switch (label) {
      case 'URGENT':
        badgeColor = Colors.red;
        break;
      case 'HIGH':
        badgeColor = Colors.orange;
        break;
      case 'MEDIUM':
        badgeColor = Colors.blue;
        break;
      case 'LOW':
      default:
        badgeColor = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor, width: 1),
      ),
      textDirection: TextDirection.ltr,
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}