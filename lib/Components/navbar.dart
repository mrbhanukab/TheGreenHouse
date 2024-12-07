import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Navbar extends StatelessWidget {
  final TabController tabController;

  const Navbar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        TabBar(
          controller: tabController,
          indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 4),
            insets: EdgeInsets.fromLTRB(16, 0, 16, 8),
          ),
          tabs: [
            SizedBox(
              height: 55,
              width: 40,
              child: Center(child: Icon(Icons.home, color: Color(0xFFEEEEE6))),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                child: Icon(Icons.notifications, color: Color(0xFFEEEEE6)),
              ),
            ),
            SizedBox(height: 55, width: 40),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                child: Icon(Icons.file_open, color: Color(0xFFEEEEE6)),
              ),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                child: Icon(Icons.settings, color: Color(0xFFEEEEE6)),
              ),
            ),
          ],
        ),
        Positioned(
          width: 70,
          height: 70,
          top: -25,
          child: FloatingActionButton(
            backgroundColor: Color(0xFFE6D2C4),
            onPressed: () {},
            shape: CircleBorder(),
            child: Lottie.asset(
              "assets/AI/Hi.json",
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ],
    );
  }
}
