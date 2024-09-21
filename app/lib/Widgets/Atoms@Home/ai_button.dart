import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AIButton extends StatelessWidget {
  const AIButton({super.key});

  @override
  Widget build(BuildContext context) {
    final double fabSize = MediaQuery.of(context).size.width * 0.15;
    return SizedBox(
      width: fabSize,
      height: fabSize,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Lottie.asset(
          "assets/AI-Hi.json",
        ),
      ),
    );
  }
}
