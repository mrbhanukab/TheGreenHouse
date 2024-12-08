import 'package:flutter/material.dart';

import '../../Components/button.dart';
import '../../Components/main_widget.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            MainWidget(
              height: 300,
              items: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You will receive your report daily, but you also have the option to request it immediately using the "Force Request" feature.',
                      style: TextStyle(
                        color: Color(0xFF040415),
                        fontSize: 24,
                        fontFamily: 'Roboto Slab',
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.20,
                      ),
                    ),
                    Button(
                      text: 'Force Request',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xFFC0C8E3),
                            content: Text(
                              'User ID copied to clipboard!',
                              style: TextStyle(color: Color(0xFF040415)),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
