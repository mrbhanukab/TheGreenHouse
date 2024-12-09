import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thegreenhouse/Screens/home.dart';

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Greenhouse',
      theme: ThemeData(
        fontFamily: GoogleFonts.robotoSlab().fontFamily,
        appBarTheme: AppBarTheme(
          toolbarHeight: 75,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.robotoSlab(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w500,
            fontSize: 28,
            color: Color(0xFF040415),
          ),
          iconTheme: IconThemeData(color: Color(0xFF040415), size: 30),
        ),
        scaffoldBackgroundColor: Color(0xFFF4F4C7),
        useMaterial3: true,
      ),
      home: SafeArea(child: const Home()),
    );
  }
}
