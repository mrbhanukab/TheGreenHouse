import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PlantCard extends StatelessWidget {
  final bool needWater;
  final Map<String, dynamic> plantData;

  const PlantCard({super.key, required this.needWater, required this.plantData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: MediaQuery.of(context).size.width * 0.35,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: needWater ? const Color(0xFFDFECDC) : const Color(0xFFF2DFDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Lottie.asset(needWater ? "assets/plant@good.json" : "assets/plant@bad.json"),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plantData['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "🚰 ${plantData['humidity']}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class PlantsList extends StatelessWidget {
  const PlantsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> plants = [
      {'name': 'Cauliflower', 'humidity': 75},
      {'name': 'Tomato', 'humidity': 40},
      {'name': 'Lettuce', 'humidity': 80},
      {'name': 'Pepper', 'humidity': 70},
      {'name': 'Cauliflower', 'humidity': 75},
      {'name': 'Tomato', 'humidity': 40},
      {'name': 'Lettuce', 'humidity': 80},
      {'name': 'Pepper', 'humidity': 70},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Plants",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w300,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: plants.map((plant) {
                return PlantCard(
                  needWater: plant['humidity'] > 50,
                  plantData: plant,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}