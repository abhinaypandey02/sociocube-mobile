import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../text.dart';

class Input extends StatelessWidget {
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final bool obscureText;
  final Color variantColor;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String?)? onChanged;

  const Input({
    super.key,
    this.hint,
    this.label,
    this.controller,
    this.obscureText = false,
    this.variantColor = AppColors.primary,
    this.validator,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              label!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontVariations: getVariations(Size.small, 400),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: variantColor,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontVariations: getVariations(Size.small, 400),
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorStyle: TextStyle(
              color: Colors.red[600],
              fontSize: 12,
              fontVariations: getVariations(Size.small, 400),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey[350]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red[600]!, width: 0.65),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red[600]!, width: 1.25),
            ),
          ),
        ),
      ],
    );
  }
}
