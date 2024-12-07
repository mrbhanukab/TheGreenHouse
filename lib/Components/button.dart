import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const Button({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Color(0xFF040415)),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 55)),
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFFF4F4C7),
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.22,
        ),
      ),
    );
  }
}
