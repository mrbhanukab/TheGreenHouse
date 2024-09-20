import 'package:flutter/material.dart';

class TemperatureAndHumidity extends StatelessWidget {
  const TemperatureAndHumidity({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.17,
      child: const Center(
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Temperature"),
                    Text(
                      "22°C",
                      style: TextStyle(
                          fontSize: 50, fontWeight: FontWeight.w600),
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
                    Text("Humidity"),
                    Text(
                      "75%",
                      style: TextStyle(
                          fontSize: 50, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
