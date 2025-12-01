import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../text.dart';

class Input extends StatelessWidget {
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final Color variantColor;
  final String? Function(String?)? validator;
  final String? errorText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final void Function(String?)? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const Input({
    super.key,
    this.hint,
    this.label,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.variantColor = AppColors.primary,
    this.validator,
    this.errorText,
    this.suffixText,
    this.keyboardType,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
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
          focusNode: focusNode,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: variantColor,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontVariations: getVariations(Size.small, 400),
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorText: errorText,
            errorStyle: TextStyle(
              color: Colors.red[600],
              fontSize: 12,
              fontVariations: getVariations(Size.small, 400),
            ),
            suffixText: suffixText,
            suffixStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
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
