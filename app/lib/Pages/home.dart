import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thegreenhouse/Widgets/Atoms@Home/ai_button.dart';
import 'package:thegreenhouse/Widgets/Atoms@Home/latest_alerts.dart';
import 'package:thegreenhouse/Widgets/Atoms@Home/plants_list.dart';
import '../Widgets/Atoms@Home/temperature_and_humidity.dart';
import '../Widgets/custom_menu.dart';
import '../Widgets/account_option.dart';
import '../Services/firestore.dart';

class Home extends StatefulWidget {
  final List<String> greenhouseNames;
  const Home({super.key, required this.greenhouseNames});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey _appBarKey = GlobalKey();
  final FirestoreService _firestoreService = FirestoreService();
  String selectedGreenhouseId = '';

  @override
  void initState() {
    super.initState();
    if (widget.greenhouseNames.isNotEmpty) {
      _handleMenuSelection(widget.greenhouseNames.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        key: _appBarKey,
        forceMaterialTransparency: true,
        leading: CustomMenu(
          onSelected: _handleMenuSelection,
          appBarKey: _appBarKey,
          greenhouseNames: widget.greenhouseNames,
        ),
        actions: [
          AccountOption(appBarKey: _appBarKey),
        ],
        title: Text(selectedGreenhouseId.isEmpty ? 'Loading...' : selectedGreenhouseId),
      ),
body: selectedGreenhouseId.isEmpty
    ? const Center(child: CircularProgressIndicator())
    : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _firestoreService.getGreenHouseInfoStream(selectedGreenhouseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!.data()!;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TemperatureAndHumidity(
                  currentEnvironment: data['current environment'] ?? {},
                  forcedLight: data['forced light'] ?? false,
                  environmentLimits: data['environment limits'] ?? {},
                  greenhouseId: selectedGreenhouseId,
                ),
                PlantsList(
                  currentEnvironment: data['current environment'] ?? {},
                  environmentLimits: data['environment limits'] ?? {},
                  greenhouseId: selectedGreenhouseId,
                ),
                LatestAlerts(alertsStream: _firestoreService.getAlertsStream(selectedGreenhouseId)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: const AIButton(),
    );
  }

  void _handleMenuSelection(String greenhouseId) {
    setState(() {
      selectedGreenhouseId = greenhouseId;
    });
  }
}