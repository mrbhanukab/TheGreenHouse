import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final Stream<List<Map<String, dynamic>>> alertsStream;

  const LatestAlerts({super.key, required this.alertsStream});

  @override
  Widget build(BuildContext context) {
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
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: alertsStream,
            builder: (context, alertSnapshot) {
              if (alertSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (alertSnapshot.hasError) {
                return const Center(child: Text('Error fetching alerts'));
              } else if (!alertSnapshot.hasData || alertSnapshot.data!.isEmpty) {
                final now = DateFormat('🗓️ yyyy-MM-dd ⌚ HH:mm').format(DateTime.now());
                return AlertCard(alertData: {'message': 'No alerts available!  😴', 'timestamp': now});
              }

              final alerts = alertSnapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: alerts.map((alert) {
                    return AlertCard(alertData: alert);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}