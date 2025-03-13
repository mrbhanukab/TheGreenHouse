import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:lottie/lottie.dart';

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

class LatestAlerts extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> alertsStream;

  const LatestAlerts({super.key, required this.alertsStream});

  @override
  _LatestAlertsState createState() => _LatestAlertsState();
}

class _LatestAlertsState extends State<LatestAlerts> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _alerts = [];

  @override
  void initState() {
    super.initState();
    _subscribeToAlerts();
  }

void _subscribeToAlerts() {
  widget.alertsStream.listen((alerts) async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    final dateFormat = DateFormat('🗓️ yyyy-MM-dd ⌚ HH:mm');
    alerts.sort((a, b) => dateFormat.parse(b['timestamp']).compareTo(dateFormat.parse(a['timestamp'])));
    setState(() {
      _alerts = alerts;
      _isLoading = false;
    });
  });
}

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
          _isLoading
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Lottie.asset(
                              "assets/alerts_loading.json",
                    width:  MediaQuery.of(context).size.width * 0.5
                            ),
                ),
              )
              : _alerts.isEmpty
                  ? AlertCard(alertData: {
                      'message': 'No alerts available!  😴',
                      'timestamp': DateFormat('🗓️ yyyy-MM-dd ⌚ HH:mm').format(DateTime.now())
                    })
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: _alerts.map((alert) {
                          return AlertCard(alertData: alert);
                        }).toList(),
                      ),
                    ),
        ],
      ),
    );
  }
}