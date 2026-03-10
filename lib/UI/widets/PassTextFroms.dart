import 'package:flutter/material.dart';

class PassTextForms extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;
  final bool visible;
  final double width;
  final String hintText;
  final String? Function(String?) validator;

  const PassTextForms({
    super.key,
    required this.onPressed,
    required this.controller,
    required this.visible,
    required this.width, required this.hintText, required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: visible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            visible ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: onPressed,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.04),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}