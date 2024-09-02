import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thegreenhouse/Services/login_flow_control.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/logo.png"), context);
    return MaterialApp(
      title: 'The Green House',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Scaffold(
          body: LoginFlowControl(),
      ),
    );
  }
}
