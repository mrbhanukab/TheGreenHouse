import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thegreenhouse/Services/login_flow_control.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

late String version;

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp( MyApp(version: version));
  });
}

class MyApp extends StatelessWidget {
  final String version;
  const MyApp({super.key, required this.version});

  @override

  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/logo.png"), context);
    return MaterialApp(
      title: 'The Green House',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Comfortaa',
      ),
      home: Scaffold(
          body: SafeArea(child: LoginFlowControl(version: version,)),
      ),
    );
  }
}
