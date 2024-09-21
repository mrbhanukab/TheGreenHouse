import 'package:flutter/material.dart';

class TemperatureHumidityInputDialog {
  final bool forcedLight;
  TemperatureHumidityInputDialog({
    required this.forcedLight,
  });
  int temperature = 22;
  int humidity = 75;

  void showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    onPressed: () {
                      if (temperature > 0) {
                        temperature--;
                      }
                    },
                  ),
                  Text('$temperature°C'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      temperature++;
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (humidity > 0) {
                        humidity--;
                      }
                    },
                  ),
                  Text('$humidity%'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      humidity++;
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Handle the input values here
                print('Temperature: $temperature');
                print('Humidity: $humidity');
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black),
              ),
              child: const Text('Update', style: TextStyle(color: Colors.white)),
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }

  Widget buildButtonGroup(BuildContext context) {
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
            onPressed: () => showInputDialog(context),
            icon: const Icon(Icons.energy_savings_leaf_outlined),
            style: buttonStyle,
          ),
          Expanded(
            child: TextButton(
              onPressed: () {},
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
}

class TemperatureAndHumidity extends StatelessWidget {
  final Map<String, dynamic> currentEnvironment;
  final bool forcedLight;
  final Map<String, dynamic> environmentLimits;

  const TemperatureAndHumidity({
    super.key,
    required this.currentEnvironment,
    required this.forcedLight,
    required this.environmentLimits,
  });

  @override
  Widget build(BuildContext context) {
    final currentTemperature = currentEnvironment['temperature'] ?? "--";
    final currentHumidity = currentEnvironment['humidity'] ?? "--";
    final limitTemperature = environmentLimits['temperature'] ?? 0;
    final limitHumidity = environmentLimits['humidity'] ?? 0;

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
          TemperatureHumidityInputDialog(forcedLight: forcedLight).buildButtonGroup(context),
        ],
      ),
    );
  }
}