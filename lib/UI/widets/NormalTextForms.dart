import 'package:flutter/material.dart';

class NormalTextForms extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final String hintText;
  final String validatorText;
  final Icon? icon;

  NormalTextForms({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validatorText,
    required this.width,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: icon != null
      ? Icon(icon!.icon, color: Colors.white70)
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.04),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? validatorText : null,
    );
  }
}