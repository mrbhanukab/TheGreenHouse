import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:thegreenhouse/Services/appwrite.dart';

class AI extends StatefulWidget {
  const AI({super.key});

  @override
  AIState createState() => AIState();
}

class AIState extends State<AI> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  String _lottieAsset = 'assets/AI/Hi.json';
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTyping);
  }

  void _onTyping() {
    if (_typingTimer?.isActive ?? false) _typingTimer?.cancel();
    setState(() {
      _lottieAsset = 'assets/AI/AI-Read.json';
    });
    _typingTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _lottieAsset = 'assets/AI/Hi.json';
      });
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;

      // Add user message to the list
      setState(() {
        _messages.insert(0, 'User: $userMessage');
        _lottieAsset = 'assets/AI/AI-Think.json';
        _controller.clear();
      });

      // Fetch greenhouse data
      final greenhouseData = await _fetchGreenhouseData();

      // Format payload
      final payload = _formatPayload(userMessage, greenhouseData);

      // Send payload to Azure OpenAI API
      final response = await _sendToAzureAPI(payload);

      // Add response to the list
      setState(() {
        _messages.insert(0, 'Ransisi: ${response ?? 'No response'}');
        _lottieAsset = 'assets/AI/Hi.json';
      });
    }
  }

  Future<Map<String, dynamic>> _fetchGreenhouseData() async {
    final appwriteService = AppwriteService();
    final document = await appwriteService.getDocument(
      '674ec2a4000fd3f493dc',
      '6751754b0027d0822482',
    );
    if (document != null) {
      return jsonDecode(document);
    }
    return {};
  }

  String _formatPayload(String userMessage,
      Map<String, dynamic> greenhouseData,) {
    final currentTime = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());
    final greenhouseInfo = '''
      Temperature: ${greenhouseData['currentTemperature']}°C,
      Humidity: ${greenhouseData['currentHumidity']}%,
      Temperature Limit: ${greenhouseData['temperatureLimit']}°C,
      Humidity Limit: ${greenhouseData['humidityLimit']}%,
      Plants: ${greenhouseData['plants']}
    ''';

    return jsonEncode({
      "messages": [
        {
          "role": "system",
          "content":
          "You are \"Ransisi,\" a friendly girl with a PhD in biosciences, biotech, and plants, working in a greenhouse.  \n\n- Greet with a friendly, time-based opening.  \n- If the user says \"hi\" or similar, share the greenhouse's current state.  \n- Answer questions based on provided data like humidity and temperature.  \n- Act human: be kind, use simple English, occasional short words (e.g., \"ig\") and emojis sparingly.  \n- Be Accurate: if you doesn't received data say it, don't say thing you haven't done\ncurrent: $currentTime\ngreenhouse: $greenhouseInfo",
        },
        {"role": "user", "content": userMessage},
      ],
      "temperature": 0.7,
      "top_p": 0.95,
      "max_tokens": 800,
      "model": "Phi-3-medium-128k-instruct",
    });
  }

  Future<String?> _sendToAzureAPI(String payload) async {
    final response = await http.post(
      Uri.parse(
        'https://it241-m4gcvy7y-eastus2.services.ai.azure.com/models/chat/completions?api-version=2024-05-01-preview',
      ),
      headers: {
        'Content-Type': 'application/json',
        'api-key': 20
        '7SgZxy1YiQBeFHAIA9zayqhD0FVmfSP3SFct9NFUG7rxFHEO5ZbZJQQJ99ALACHYHv6XJ3w3AAAAACOG9egD',
      },
      body: payload,
    );
    print(response.body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(
        'Response from Azure API: ${responseData['choices'][0]['message']['content']}',
      );
      return responseData['choices'][0]['message']['content'];
    } else {
      print('Failed to get response from Azure API: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Lottie.asset(_lottieAsset, width: 50, height: 50),
            const SizedBox(width: 8),
            const Text('Ransisi'),
          ],
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.startsWith('User:');
                return Align(
                  alignment:
                  isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: message.replaceFirst(
                            isUserMessage ? 'User: ' : 'Ransisi: ',
                            '',
                          ),
                        ),
                        textAlign:
                        isUserMessage ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                          color: isUserMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: Colors.white,
                hintStyle: const TextStyle(color: Colors.black54),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: _sendMessage,
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
