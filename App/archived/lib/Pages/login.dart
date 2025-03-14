import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:thegreenhouse/Services/google_signin.dart';

class Login extends StatelessWidget {
  final String version;
  const Login({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/logo.png"), context);
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
                  Color.fromRGBO(255, 255, 255, 1),
                  Color.fromRGBO(76, 143, 54, 0.60),
                ],
                stops: [-0.0123, 1.0202],
              ),
            ),
          ),

          // Content and Logo
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and Title
                 Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Image(
                              image: AssetImage("assets/logo.png"),
                              width: 95,
                              height: 95,
                            ),
                            const Text(
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
                              "Version $version",
                              style: const TextStyle(
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

                // Login Container
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10), // Add margin for spacing
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const AutoSizeText(
                          "Ready to cultivate the future? Unlock powerful tools to manage your state-of-the-art greenhouse by",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                          maxLines: 5,
                        ),
                        // Google Sign-in Button
                        InkWell(
                          onTap: () => AuthService().signInWithGoogle(),
                          borderRadius: BorderRadius.circular(15), // Optional: to match the container's border radius
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: AutoSizeText(
                                "Continue with Google",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
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