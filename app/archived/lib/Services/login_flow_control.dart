import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thegreenhouse/Pages/login.dart';
import 'package:thegreenhouse/Services/firestore.dart';
import '../Pages/home.dart';
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
            return StreamBuilder<List<String>>(
              stream: FirestoreService().getUserGreenhousesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const HaventAssign();
                } else {
                  return Home(greenhouseNames: snapshot.data!);
                }
              },
            );
          } else {
            return Login(version: version);
          }
        },
      ),
    );
  }
}