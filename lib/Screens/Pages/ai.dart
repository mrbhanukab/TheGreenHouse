import 'package:flutter/material.dart';

class AI extends StatelessWidget {
  const AI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Ransisi'),
      ),
      body: Center(
        child: Text("AI", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}
