import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:thegreenhouse/Widgets/Atoms@Home/ai_popup.dart';

class AIButton extends StatelessWidget {
  final int temperature;
  final int humidity;

  const AIButton({
    super.key,
    required this.temperature,
    required this.humidity,
  });

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AIChatScreen(
                temperature: temperature,
                humidity: humidity,
              ),
            ),
          );
        },
        child: Lottie.asset(
          "assets/AI-Hi.json",
        ),
      ),
    );
  }
}