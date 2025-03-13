import 'package:flutter/material.dart';
import 'package:thegreenhouse/Components/button.dart';
import 'package:thegreenhouse/Components/main_widget.dart';

class AccessNull extends StatelessWidget {
  const AccessNull({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        backgroundColor: Color(0xFF040415),
        child: Icon(Icons.logout, color: Color(0xFFF4F4C7)),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            MainWidget(
              height: MediaQuery.of(context).size.height * 0.85,
              items: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome,\n',
                            style: TextStyle(
                              color: Color(0xFF040415),
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.24,
                              height: 0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'Bhanuka!',
                            style: TextStyle(
                              color: Color(0xFF040415),
                              fontSize: 45,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.40,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nUnfortunately, you haven’t been assigned to any greenhouses yet. Please copy your user ID and send it to the IT guy, asking him/her to assign you to the relevant greenhouse(s).',
                            style: TextStyle(
                              color: Color(0xFF040415),
                              fontSize: 24,
                              fontFamily: 'Roboto Slab',
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Button(
                      text: 'Copy User ID',
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
