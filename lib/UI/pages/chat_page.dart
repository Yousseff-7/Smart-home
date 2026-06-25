import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../services/chat_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() =>
      _ChatPageState();
}

class _ChatPageState
    extends State<ChatPage> {

  final ChatService chatService =
  ChatService();

  final TextEditingController controller =
  TextEditingController();

  late stt.SpeechToText speech;

  bool isListening = false;
  bool loading = false;

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();

    speech = stt.SpeechToText();
  }

  Future startListening() async {

    bool available =
    await speech.initialize();

    print("AVAILABLE = $available");

    if (available) {

      setState(() {
        isListening = true;
      });

      speech.listen(

        listenFor: const Duration(seconds: 8),

        pauseFor: const Duration(seconds: 3),

        onResult: (result) {

          controller.text =
              result.recognizedWords;

        },

      );
    }
  }

  Future stopListening() async {

    await speech.stop();

    await speech.cancel();

    setState(() {

      isListening = false;

    });

  }

  Future sendMessage() async {

    if(controller.text.trim().isEmpty) return;

    if(isListening){
      await stopListening();
    }

    String userMessage = controller.text;

    controller.clear();

    setState(() {

      messages.add({

        "text": userMessage,
        "isUser": true,

      });

      loading = true;

    });

    String reply =
    await chatService.sendMessage(
      userMessage,
    );

    setState(() {

      messages.add({

        "text": reply,
        "isUser": false,

      });

      loading = false;

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor:
        Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "AI Assistant",
          style: TextStyle(
            color: Theme.of(context)
                .textTheme
                .titleLarge
                ?.color,
          ),
        ),
      ),
      body: Column(

        children: [

          Expanded(

            child: ListView.builder(

              padding:
              const EdgeInsets.all(15),

              itemCount:
              messages.length,

              itemBuilder:
                  (context, index) {

                final msg =
                messages[index];

                return Align(

                  alignment:

                  msg["isUser"]

                      ? Alignment.centerRight
                      : Alignment.centerLeft,

                  child: Container(

                    margin:
                    const EdgeInsets.only(
                      bottom: 10,
                    ),

                    padding:
                    const EdgeInsets.all(
                      12,
                    ),

                    decoration:
                    BoxDecoration(

                      color: msg["isUser"]
                          ? Colors.orange
                          : Theme.of(context).cardColor,

                      borderRadius:
                      BorderRadius.circular(
                        15,
                      ),

                    ),

                    child: Text(

                      msg["text"],

                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color,
                      ),
                    ),

                  ),

                );

              },

            ),

          ),

          if (loading)

            Padding(

              padding:
              const EdgeInsets.all(10),

              child:
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),

            ),

          Container(

            padding:
            const EdgeInsets.all(12),

            child: Row(

              children: [

                Expanded(

                  child: TextField(

                    controller:
                    controller,

                    decoration:
                    const InputDecoration(

                      hintText:
                      "Ask AI...",

                    ),

                  ),

                ),

                IconButton(

                  onPressed: () {

                    if (isListening) {

                      stopListening();

                    } else {

                      startListening();

                    }

                  },

                  icon: Icon(

                    isListening

                        ? Icons.mic
                        : Icons.mic_none,

                    color:

                    isListening

                        ? Colors.red
                        : Colors.orange,

                  ),

                ),

                IconButton(

                  onPressed:
                  sendMessage,

                  icon: const Icon(

                    Icons.send,

                    color:
                    Colors.orange,

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }
}