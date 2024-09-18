import 'package:flutter/material.dart';
import 'package:thegreenhouse/Widgets/Atoms@Home/ai_button.dart';
import 'package:thegreenhouse/Widgets/Atoms@Home/latest_alerts.dart';
import 'package:thegreenhouse/Widgets/Atoms@Home/plants_list.dart';
import '../Widgets/Atoms@Home/temperature_and_humidity.dart';
import '../Widgets/custom_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey _appBarKey = GlobalKey();

  Future<void> _handleRefresh() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    await Future.delayed(const Duration(seconds: 2));
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Latest update: 2 minutes ago!',
          style: TextStyle(color: Colors.white),
        ),
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
        elevation: 5,
      ),
    );
  }

  void _handleMenuSelection(String result) {
    print('Selected: $result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set Scaffold background color to white
      appBar: AppBar(
        key: _appBarKey,
        forceMaterialTransparency: true,
        leading: CustomMenu(
          onSelected: _handleMenuSelection,
          appBarKey: _appBarKey,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Add your onPressed code here!
            },
          ),
        ],
        title: const Text('Malabe GH 1'),
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: _handleRefresh,
        child: const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TemperatureAndHumidity(),
              PlantsList(),
              LatestAlerts(),
            ],
          ),
        ),
      ),
      floatingActionButton: const AIButton()
    );
  }
}