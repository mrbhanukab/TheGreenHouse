import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:thegreenhouse/Components/navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomBar(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        iconDecoration: BoxDecoration(color: Color(0xFFEEEEE6)),
        barDecoration: BoxDecoration(
          color: Color(0xFF040415),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Color(0x66040415),
              blurRadius: 20,
              offset: Offset(0, 0),
            ),
          ],
        ),
        width: double.infinity,
        child: Navbar(tabController: tabController),
        body:
            (context, controller) => Center(
              child: Text(
                "Testing BottomBar",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
      ),
    );
  }
}
