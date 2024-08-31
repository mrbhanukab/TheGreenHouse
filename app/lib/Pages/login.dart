import 'package:flutter/material.dart';
import 'package:thegreenhouse/Services/google_signin.dart';

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
            padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and Title (Flex for responsiveness)
                const Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage("assets/logo.png"),
                              width: 95,
                              height: 95,
                            ),
                            Text(
                              "The Green\nHouse",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                letterSpacing: 1.5,
                                height: 1.15,
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Version 2.0.1",
                              style: TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Login Container (Flex for responsiveness)
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(
                        bottom: 10), // Add margin for spacing
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Ready to cultivate the future? Unlock powerful tools to manage your state-of-the-art greenhouse by",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        // Google Sign-in Button
                        InkWell(
                          onTap: () => AuthService().signInWithGoogle(),
                          borderRadius: BorderRadius.circular(
                              15), // Optional: to match the container's border radius
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
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
