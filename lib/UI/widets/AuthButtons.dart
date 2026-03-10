import 'package:flutter/material.dart';

class Authbutton extends StatelessWidget {
  final String text;

  final dynamic height;
  final dynamic width;

  const Authbutton({
    super.key,
    required this.text,
    required this.height,
    required this.width,
  }); // constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.07,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.04),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2235), Color(0xFF2C5364)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: width * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
