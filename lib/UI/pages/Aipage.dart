import 'package:flutter/material.dart';
import '../../models/ai_prediction_model.dart';
import '../../services/ai_service.dart';

class AIPage extends StatefulWidget {

  final String deviceId;

  const AIPage({

    super.key,
    required this.deviceId,

  });

  @override
  State<AIPage> createState() =>
      _AIPageState();
}

class _AIPageState
    extends State<AIPage> {

  final AIService aiService =
  AIService();

  AIPredictionModel? prediction;

  bool loading = true;

  @override
  void initState() {

    super.initState();

    loadPrediction();
  }

  Future<void> loadPrediction() async {

    print("DEVICE ID => ${widget.deviceId}");

    prediction = await aiService.getPrediction(
      widget.deviceId,
    );

    print("PREDICTION => $prediction");

    if (prediction != null) {
      print("STATUS => ${prediction!.status}");
      print("STATE => ${prediction!.state}");
      print("RECOMMENDATION => ${prediction!.recommendation}");
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
        const Text("AI Analysis"),
      ),

      body:

      loading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : prediction == null

          ? const Center(
        child: Text(
          "AI Prediction Not Found",
          style: TextStyle(fontSize: 18),
        ),
      )

          : Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Card(

              child: ListTile(

                title:
                const Text("Status"),

                subtitle:
                Text(
                  prediction!.status,
                ),

              ),

            ),

            const SizedBox(height: 15),

            Card(

              child: ListTile(

                title:
                const Text("Device State"),

                subtitle:
                Text(
                  prediction!.state,
                ),

              ),

            ),

            const SizedBox(height: 15),

            Card(

              child: Padding(

                padding:
                const EdgeInsets.all(16),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "Recommendation",

                      style: TextStyle(

                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                    const SizedBox(
                        height: 10),

                    Text(

                      prediction!
                          .recommendation,

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