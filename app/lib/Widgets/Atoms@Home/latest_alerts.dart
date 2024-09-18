import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final Map<String, dynamic> alertData;

  const AlertCard({super.key, required this.alertData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xC3000000), // Set the border color
          width: 1.0, // Set the border width
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            alertData['message'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            alertData['timestamp'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class LatestAlerts extends StatelessWidget {
  const LatestAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alerts = [
      {'message': 'Alex has Entered this Greenhouse!', 'timestamp': '2024.05.12 | 18:23'},
      {'message': 'Temperature is too high!', 'timestamp': '2024.05.12 | 18:25'},
      {'message': 'Humidity is too low!', 'timestamp': '2024.05.12 | 18:30'},
      {'message': 'Water level is low!', 'timestamp': '2024.05.12 | 18:35'},
      {'message': 'Linux has Entered this Greenhouse!', 'timestamp': '2024.05.12 | 18:23'},
      {'message': 'Temperature is too high!', 'timestamp': '2024.05.12 | 18:25'},
      {'message': 'Humidity is too low!', 'timestamp': '2024.05.12 | 18:30'},
      {'message': 'Water level is low!', 'timestamp': '2024.05.12 | 18:35'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alerts & Logs",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w300,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: alerts.map((alert) {
                return AlertCard(alertData: alert);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}