import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thegreenhouse/Pages/login.dart';

import '../Pages/havent_assign.dart';


class LoginFlowControl extends StatelessWidget {
  final String version;
  const LoginFlowControl({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HaventAssign();
            } else {
              return Login(version: version,);
            }
          }),
    );
  }
}
