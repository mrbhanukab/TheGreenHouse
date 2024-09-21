import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlantCard extends StatelessWidget {
  final bool needWater;
  final Map<String, dynamic> plantData;

  const PlantCard(
      {super.key, required this.needWater, required this.plantData});

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
                color: needWater
                    ? const Color(0xFFDFECDC)
                    : const Color(0xFFF2DFDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                needWater ? "assets/plant@good.svg" : "assets/plant@bad.svg",
                width: MediaQuery.of(context).size.width * 0.35,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 10),
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
                  "🚰 ${plantData['moisture']}% (${plantData['limit']==0 ? '--' : plantData['limit']}%)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {},
                      color: Colors.black,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Colors.white.withOpacity(0.8)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                      color: Colors.black,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Colors.white.withOpacity(0.8)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantsList extends StatelessWidget {
  final Map<String, dynamic> currentEnvironment;
  final Map<String, dynamic> environmentLimits;

  const PlantsList({
    super.key,
    required this.currentEnvironment,
    required this.environmentLimits,
  });

  @override
  Widget build(BuildContext context) {
    final currentMoisture = currentEnvironment['moisture'];
    final limitMoisture = environmentLimits['moisture'];

    if (currentMoisture is! Map<String, dynamic> || limitMoisture is! Map<String, dynamic>) {
      return const Center(
        child: AutoSizeText(
          "Something went wrong, most probably there is no plants registered yet.",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.w600,
              color: Colors.red
          ),
          maxLines: 3,
        ),
      );
    }

    final List<Map<String, dynamic>> plants = currentMoisture.keys.map((plantName) {
      return {
        'name': plantName,
        'moisture': currentMoisture[plantName] ?? 0,
        'limit': limitMoisture[plantName] ?? 0,
      };
    }).toList();

    // Sort alphabetically by name first, then by moisture level
    plants.sort((a, b) {
      int nameComparison = a['name'].compareTo(b['name']);
      if (nameComparison != 0) {
        return nameComparison;
      }
      return a['moisture'].compareTo(b['moisture']);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        if (plants.isEmpty) {
          return const Center(
            child: Text(
              'No plants available',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          width: constraints.maxWidth,
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
                      needWater: plant['moisture'] >= plant['limit'],
                      plantData: plant,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}