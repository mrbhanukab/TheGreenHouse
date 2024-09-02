import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thegreenhouse/Pages/login.dart';


class LoginFlowControl extends StatelessWidget {
  const LoginFlowControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = FirebaseAuth.instance.currentUser!;
              return Center(
                child: Text("Hi ${user.displayName}"),
              );
            } else {
              return const Login();
            }
          }),
    );
  }
}
