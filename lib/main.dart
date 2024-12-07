import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thegreenhouse/Screens/home.dart';

void main() {
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
        scaffoldBackgroundColor: Color(0xFFF4F4C7),
        useMaterial3: true,
      ),
      home: SafeArea(child: const Home()),
    );
  }
}
