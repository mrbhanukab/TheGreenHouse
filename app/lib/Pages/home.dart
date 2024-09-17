import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Widgets/custom_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey _appBarKey = GlobalKey();
  bool _showUpdateText = false;

  Future<void> _handleRefresh() async {
    setState(() {
      _showUpdateText = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _showUpdateText = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double fabSize = MediaQuery.of(context).size.width * 0.15;

    return Scaffold(
      backgroundColor: Colors.white, // Set Scaffold background color to white
      appBar: AppBar(
        key: _appBarKey,
        forceMaterialTransparency: true,
        leading: Builder(
          builder: (context) => CustomMenu(
            onSelected: (String result) {
              // Handle menu item selection
              switch (result) {
                case 'Item 1':
                  break;
                case 'Item 2':
                  // Add your code for Item 2
                  break;
                case 'Item 3':
                  // Add your code for Item 3
                  break;
              }
            },
            appBarKey: _appBarKey,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Add your onPressed code here!
            },
          ),
        ],
        title: const Text('Malabe GH 1'),
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              if (_showUpdateText)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(
                    "Latest update just now!",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                  ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
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
              ),
              Container(
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
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.23,
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
                                color: const Color(0xFFDFECDC),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Lottie.asset("assets/plant@good.json")
                                    ),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cauliflower",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "🚰 75%",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.23,
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
                                          color: const Color(0xFFF2DFDF),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Lottie.asset("assets/plant@bad.json")
                                    ),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cauliflower",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "🚰 15%",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.23,
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
                                          color: const Color(0xFFDFECDC),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Lottie.asset("assets/plant@good.json")
                                    ),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cauliflower",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "🚰 75%",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.23,
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
                                          color: const Color(0xFFDFECDC),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Lottie.asset("assets/plant@good.json")
                                    ),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cauliflower",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "🚰 75%",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
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
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xC3000000),// Set the border color
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Alex has Entered this Greenhouse!',style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),),
                                Text('2024.05.12 | 18:23',style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xC3000000),// Set the border color
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Alex has Entered this Greenhouse!',style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),),
                                Text('2024.05.12 | 18:23',style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xC3000000),// Set the border color
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Alex has Entered this Greenhouse!',style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),),
                                Text('2024.05.12 | 18:23',style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xC3000000),// Set the border color
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Alex has Entered this Greenhouse!',style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),),
                                Text('2024.05.12 | 18:23',style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xC3000000),// Set the border color
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Alex has Entered this Greenhouse!',style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),),
                                Text('2024.05.12 | 18:23',style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xC3000000),// Set the border color
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Alex has Entered this Greenhouse!',style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),),
                                Text('2024.05.12 | 18:23',style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: fabSize,
        height: fabSize,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            // Add your onPressed code here!
          },
          child: Lottie.asset(
            "assets/AI-Hi.json",
          ),
        ),
      ),
    );
  }
}
