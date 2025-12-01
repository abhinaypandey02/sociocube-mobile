import 'package:flutter/material.dart';

import '../../../core/widgets/text.dart';
import '../../../core/theme/app_colors.dart';

class RoleSelector extends StatelessWidget {
  final bool isSelected;
  final void Function() onSelect;
  final String title;
  final String subtitle;
  const RoleSelector({
    super.key,
    required this.isSelected,
    required this.onSelect,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300.withOpacity(0.7),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontVariations: getVariations(Size.medium, 500),
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              children: [
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
