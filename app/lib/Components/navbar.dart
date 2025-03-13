import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:thegreenhouse/Screens/Pages/ai.dart';

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
          labelColor: Color(0xFFA9B8EE),
          unselectedLabelColor: Color(0xFFEEEEE6),
          tabs: [
            SizedBox(
              height: 55,
              width: 40,
              child: Center(child: Icon(Icons.home)),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(child: Icon(Icons.notifications)),
            ),
            SizedBox(height: 55, width: 40),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(child: Icon(Icons.file_open)),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(child: Icon(Icons.settings)),
            ),
          ],
        ),
        Positioned(
          width: 75,
          height: 75,
          top: -35,
          child: FloatingActionButton(
            backgroundColor: Color(0xFFE6D2C4),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AI()),
              );
            },
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
