import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class HaventAssign extends StatelessWidget {
  const HaventAssign({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(255, 255, 255, 0.8),
                      Color.fromRGBO(255, 101, 132, 0.6),
                    ],
                    stops: [-0.0123, 1.0202],
                  ),
                ),
              ),

              // Content using Flex for responsiveness
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 3, // 2/3 of the screen
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            "assets/haventAssigned.json",
                            width: constraints.maxWidth * 0.6,
                            height: null,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: AutoSizeText(
                              "We're pretty sure plants need someone to take care of them. They're just waiting for you!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2, // 1/3 of the screen
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
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
                              "Unfortunately,  you haven’t been assigned to any greenhouses yet. Please copy your user ID and send it to the IT guy, asking him/her to assign you to the relevant greenhouse(s).",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                              maxLines: 6,
                            ),
                            // Copy UID Button
                            InkWell(
                              onTap: () => _copyUID(context, user.uid),
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.copy, size: 25),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AutoSizeText(
                                          "Copy User ID",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                          width: constraints.maxWidth * 0.6, // Constrain the width
                                          child: Text(
                                            user.uid,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            overflow: TextOverflow.ellipsis, // Set overflow property
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
          );
        },
      ),
    );
  }
}

void _copyUID(BuildContext context, String uid) {
  Clipboard.setData(ClipboardData(text: uid));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'User ID copied to clipboard successfully!',
        style: TextStyle(color: Colors.black),
      ),
      shape: StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
      elevation: 5,
    ),
  );
}
