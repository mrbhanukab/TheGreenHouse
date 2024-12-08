import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Dashboard",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
