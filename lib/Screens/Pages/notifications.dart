import 'package:flutter/material.dart';
import 'package:thegreenhouse/Components/alert.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Alert(
                type: TYPE.error,
                title: 'Alert Title',
                msg: 'Alert Message',
              ),
            );
          },
        ),
      ),
    );
  }
}
