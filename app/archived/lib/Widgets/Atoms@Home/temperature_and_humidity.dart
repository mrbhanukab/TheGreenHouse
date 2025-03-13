import 'package:flutter/material.dart';
import '../../Services/firestore.dart';

class TemperatureHumidityInputDialog extends StatefulWidget {
  final bool forcedLight;
  final int currentTemperature;
  final int currentHumidity;
  final int limitTemperature;
  final int limitHumidity;
  final String greenhouseId;
  @override
  final Key? key;

  const TemperatureHumidityInputDialog({
    required this.forcedLight,
    required this.currentTemperature,
    required this.currentHumidity,
    required this.limitTemperature,
    required this.limitHumidity,
    required this.greenhouseId,
    this.key,
  }) : super(key: key);

  @override
  TemperatureHumidityInputDialogState createState() => TemperatureHumidityInputDialogState();
}

class TemperatureHumidityInputDialogState extends State<TemperatureHumidityInputDialog> {
  late int temperature;
  late int humidity;

  @override
  void initState() {
    super.initState();
    temperature = widget.limitTemperature != 0 ? widget.limitTemperature : widget.currentTemperature;
    humidity = widget.limitHumidity != 0 ? widget.limitHumidity : widget.currentHumidity;
  }

  void _updateTemperature(int change) {
    setState(() {
      temperature += change;
    });
  }

  void _updateHumidity(int change) {
    setState(() {
      humidity += change;
    });
  }

  void _updateFirestore() async {
    await FirestoreService().updateEnvironmentLimits(widget.greenhouseId, temperature, humidity);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Temperature and Humidity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => _updateTemperature(-1),
              ),
              Text('$temperature°C'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _updateTemperature(1),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => _updateHumidity(-1),
              ),
              Text('$humidity%'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _updateHumidity(1),
              ),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _updateFirestore,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.black),
          ),
          child: const Text('Update', style: TextStyle(color: Colors.white)),
        ),
      ],
      backgroundColor: Colors.white,
    );
  }
}

class TemperatureAndHumidity extends StatefulWidget {
  final Map<String, dynamic> currentEnvironment;
  final bool forcedLight;
  final Map<String, dynamic> environmentLimits;
  final String greenhouseId;
  @override
  final Key? key;

  const TemperatureAndHumidity({
    required this.currentEnvironment,
    required this.forcedLight,
    required this.environmentLimits,
    required this.greenhouseId,
    this.key,
  }) : super(key: key);

  @override
  TemperatureAndHumidityState createState() => TemperatureAndHumidityState();
}

class TemperatureAndHumidityState extends State<TemperatureAndHumidity> {
  late bool forcedLight;

  @override
  void initState() {
    super.initState();
    forcedLight = widget.forcedLight;
  }

  void _toggleForcedLight() async {
    final newForcedLight = !forcedLight;
    await FirestoreService().updateForcedLight(widget.greenhouseId, newForcedLight);
    if (mounted) {
      setState(() {
        forcedLight = newForcedLight;
      });
    }
  }

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TemperatureHumidityInputDialog(
          forcedLight: forcedLight,
          currentTemperature: widget.currentEnvironment['temperature'] ?? 0,
          currentHumidity: widget.currentEnvironment['humidity'] ?? 0,
          limitTemperature: widget.environmentLimits['temperature'] ?? 0,
          limitHumidity: widget.environmentLimits['humidity'] ?? 0,
          greenhouseId: widget.greenhouseId,
        );
      },
    );
  }

  Widget _buildButtonGroup() {
    final buttonStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.black),
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black),
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _showInputDialog,
            icon: const Icon(Icons.energy_savings_leaf_outlined),
            style: buttonStyle,
          ),
          Expanded(
            child: TextButton(
              onPressed: _toggleForcedLight,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(forcedLight ? Colors.white : Colors.black),
                backgroundColor: WidgetStateProperty.all(forcedLight ? Colors.black : Colors.transparent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              child: const Text("Forced Light ON"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTemperature = widget.currentEnvironment['temperature'] ?? 0;
    final currentHumidity = widget.currentEnvironment['humidity'] ?? 0;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Temperature"),
                      Text(
                        "$currentTemperature°C",
                        style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Humidity"),
                      Text(
                        "$currentHumidity%",
                        style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildButtonGroup(),
        ],
      ),
    );
  }
}