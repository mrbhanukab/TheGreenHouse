import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIChatScreen extends StatefulWidget {
  final int temperature;
  final int humidity;

  const AIChatScreen({
    super.key,
    required this.temperature,
    required this.humidity,
  });

  @override
  AIChatScreenState createState() => AIChatScreenState();
}

class AIChatScreenState extends State<AIChatScreen> {
  late final GenerativeModel _model;
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  String _lottieAsset = 'assets/AI-Hi.json';
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _initializeModel();
    _controller.addListener(_onTyping);
  }

  void _onTyping() {
    if (_typingTimer?.isActive ?? false) _typingTimer?.cancel();
    setState(() {
      _lottieAsset = 'assets/AI-Read.json';
    });
    _typingTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _lottieAsset = 'assets/AI-Hi.json';
      });
    });
  }

  Future<void> _initializeModel() async {
    try {
      var apiKey = dotenv.env['apiKey'];
      if (apiKey != null) {
        _model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            temperature: 1,
            topK: 64,
            topP: 0.95,
            maxOutputTokens: 8192,
            responseMimeType: 'text/plain',
          ),
          systemInstruction: Content.system(
              'Your are a friendly girl name "ransisi", who having a phd in bio science, bio tech and plants. Your are working on a green house. when user talk to you he will send you current environment data like humidity and temperature. You always start chat by a friendly greeting. If user just say hi, or variants of it, you have to give insight about current state of the green house, when user ask a question you have to answer it according to current state. You should act like a good, educated, kind person rather than a bot. Be like a human, use simple english. You must include short words (for example ig= i guess) which commonly used, but don\'t use lot!'),
        );
      }
    } catch (e) {
      print('Error initializing GenerativeModel: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;

      // Add user message to the list
      setState(() {
        _messages.insert(0, 'User: $userMessage');
        _lottieAsset = 'assets/AI-Think.json';
        _controller.clear();
      });

      final chat = _model.startChat(history: []);
      final environmentData =
          'Temperature: ${widget.temperature}°C, Humidity: ${widget.humidity}%';
      final content = Content.text('$userMessage\n$environmentData');
      final response = await chat.sendMessage(content);

      // Simulate typing effect
      for (int i = 0; i < (response.text?.length ?? 0); i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() {
          _lottieAsset = 'assets/AI-Write.json';
        });
      }

      // Add Gemini response to the list
      setState(() {
        _messages.insert(0, 'Ransisi: ${response.text ?? 'No response'}');
        _lottieAsset = 'assets/AI-Hi.json';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Lottie.asset(
              _lottieAsset,
              width: 40,
              height: 40,
            ),
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
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        message.replaceFirst(
                            isUserMessage ? 'User: ' : 'Ransisi: ', ''),
                        textAlign:
                            (isUserMessage ? TextAlign.right : TextAlign.left),
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
