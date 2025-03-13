import 'package:flutter/material.dart';

class MainWidget extends StatelessWidget {
  final Widget items;
  final double height;

  const MainWidget({super.key, required this.items, this.height = 352});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: ShapeDecoration(
        color: Color(0xFFC0C8E3),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFF040415)),
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      child: items,
    );
  }
}
