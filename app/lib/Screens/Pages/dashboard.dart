import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Components/button.dart';
import '../../Components/main_widget.dart';
import '../../Services/appwrite.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? _document;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDocument();
  }

  Future<void> _fetchDocument() async {
    setState(() {
      _isLoading = true;
    });
    final appwriteService = AppwriteService();
    final document = await appwriteService.getDocument(
      '674ec2a4000fd3f493dc',
      '6751754b0027d0822482',
    );
    if (document != null) {
      setState(() {
        _document = jsonDecode(document);
        _document!['collectionId'] = '674ec2a4000fd3f493dc';
        _document!['id'] = '6751754b0027d0822482';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleForcedLight() async {
    if (_document != null) {
      final appwriteService = AppwriteService();
      final updated = await appwriteService.updateDocument(
        _document!['collectionId'],
        _document!['id'],
        {'forcedLight': !_document!['forcedLight']},
      );
      if (updated) {
        _fetchDocument();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _document == null
              ? Center(child: Text('No data found'))
              : RefreshIndicator(
                onRefresh: _fetchDocument,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      MainWidget(
                        height: MediaQuery.of(context).size.height * 0.55,
                        items: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Flex(
                            direction: Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 250,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/test.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: StatusIndicator(
                                        online: _document!['online'],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Flex(
                                      direction: Axis.vertical,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#${_document!['name']}',
                                          style: TextStyle(
                                            color: Color(0xFF040415),
                                            fontSize: 36,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.36,
                                          ),
                                        ),
                                        Text(
                                          _document!['location'],
                                          style: TextStyle(
                                            color: Color(0xFF040415),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: 0.20,
                                            height: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      InfoComponent(
                                        icon:
                                            Icons
                                                .local_fire_department_outlined,
                                        current:
                                            '${_document!['currentTemperature']}',
                                        limit:
                                            '/${_document!['temperatureLimit']}°C',
                                      ),
                                      InfoComponent(
                                        icon: Icons.water_drop_outlined,
                                        current:
                                            '${_document!['currentHumidity']}',
                                        limit:
                                            '/${_document!['humidityLimit']}%',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Button(
                                    text:
                                        _document!['forcedLight']
                                            ? "Light OFF"
                                            : "Forced Light ON",
                                    onPressed: _toggleForcedLight,
                                  ),
                                  Button(
                                    text: "Change Limits",
                                    onPressed: () => {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      PlantsList(
                        plants: List<Map<String, dynamic>>.from(
                          _document!['plants'],
                        ),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
    );
  }
}

class InfoComponent extends StatelessWidget {
  final IconData icon;
  final String current;
  final String limit;

  const InfoComponent({
    super.key,
    required this.icon,
    required this.current,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 7),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: current,
                style: TextStyle(
                  color: Color(0xFF040415),
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.20,
                ),
              ),
              TextSpan(
                text: limit,
                style: TextStyle(
                  color: Color(0xFF040415),
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final bool online;

  const StatusIndicator({super.key, required this.online});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        color: online ? Colors.green : Colors.yellow,
        shape: BoxShape.circle,
      ),
    );
  }
}

class PlantsList extends StatelessWidget {
  final List<Map<String, dynamic>> plants;

  const PlantsList({super.key, required this.plants});

  @override
  Widget build(BuildContext context) {
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
                  height: 2,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      plants.map((plant) {
                        return PlantCard(
                          needWater:
                              plant['currentMoisture'] >=
                              plant['moistureLimits'],
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

class PlantCard extends StatefulWidget {
  final bool needWater;
  final Map<String, dynamic> plantData;

  const PlantCard({
    super.key,
    required this.needWater,
    required this.plantData,
  });

  @override
  _PlantCardState createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  late int _moistureLimit;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _moistureLimit = int.parse(widget.plantData['moistureLimits'].toString());
  }

  void _updateMoistureLimit(int change) {
    setState(() {
      _moistureLimit += change;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _updateDatabase();
    });
  }

  Future<void> _updateDatabase() async {
    final appwriteService = AppwriteService();
    final collectionId = widget.plantData['collectionId'];
    final id = widget.plantData['id'];

    if (collectionId != null && id != null) {
      await appwriteService.updatePlantMoistureLimit(
        collectionId,
        id,
        _moistureLimit,
      );
    } else {
      print('Error: collectionId or id is null');
    }
  }

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
                color:
                    widget.needWater
                        ? const Color(0xFFDFECDC)
                        : const Color(0xFFF2DFDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                widget.needWater
                    ? "assets/plant@good.svg"
                    : "assets/plant@bad.svg",
                width: MediaQuery.of(context).size.width * 0.35,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.plantData['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "🚰 ${widget.plantData['currentMoisture']}% ($_moistureLimit%)",
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
                      onPressed: () => _updateMoistureLimit(-1),
                      color: Colors.black,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _updateMoistureLimit(1),
                      color: Colors.black,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
