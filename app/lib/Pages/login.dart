import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.50),
                  Color.fromRGBO(76, 143, 54, 0.50),
                ],
                stops: [-0.0123, 1.0202],
              ),
            ),
          ),

          // Content and Logo
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and Title (Flex for responsiveness)
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/logo.png",
                            width: 95,
                            height: 95,
                          ),
                          const Text(
                            "The Green\nHouse",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "Version 2.0.1",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Login Container (Flex for responsiveness)
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20), // Add margin for spacing
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ready to cultivate the future? Unlock powerful tools to manage your state-of-the-art greenhouse by",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Google Sign-in Button
                        GestureDetector(
                          onTap: () {}, // Add your login logic here
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}