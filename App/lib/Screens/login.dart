import 'package:flutter/material.dart';
import 'package:thegreenhouse/Components/button.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The\nGreen\nHouse',
              style: TextStyle(
                color: Color(0xFF040415),
                fontSize: 70,
                fontWeight: FontWeight.w900,
                height: 0.9,
                letterSpacing: 0.70,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/logo.png", width: 70),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Seeds to Trees,\n',
                            style: TextStyle(
                              color: Color(0xFF040415),
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              height: 0.8,
                              letterSpacing: 0.35,
                            ),
                          ),
                          TextSpan(
                            text: 'Simplified!',
                            style: TextStyle(
                              color: Color(0xFF040415),
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              letterSpacing: 0.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  'The Next Generation Awaits You!',
                  style: TextStyle(
                    color: Color(0xFF040415),
                    fontSize: 22,
                    fontWeight: FontWeight.w100,
                    letterSpacing: 0.22,
                  ),
                ),
                SizedBox(height: 20),
                Button(text: 'Continue with Google', onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
