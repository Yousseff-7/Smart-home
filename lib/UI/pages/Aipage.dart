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
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final AIService aiService = AIService();

  AIPredictionModel? prediction;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPrediction();
  }

  Future<void> loadPrediction() async {
    try {
      print("DEVICE ID => ${widget.deviceId}");

      prediction = await aiService.getPrediction(widget.deviceId);

      print(prediction);

    } catch (e, s) {

      print(e);
      print(s);

    } finally {

      if (mounted) {
        setState(() {
          loading = false;
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final bool deviceOff =
        prediction != null &&
            prediction!.state.toLowerCase() == "off";

    final String status =
    deviceOff ? "normal" : prediction?.status ?? "";

    final String deviceState =
    deviceOff ? "off" : prediction?.state ?? "";

    final String recommendation =
    deviceOff
        ? "No recommendation"
        : prediction?.recommendation ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Analysis"),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : prediction == null
          ? const Center(
        child: Text(
         "No AI analysis available yet The device has not sent any sensor readings",
          style: TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text("Status"),
                subtitle: Text(
                  status,
                  style: TextStyle(
                    color: deviceOff
                        ? Colors.green
                        : status == "anomaly"
                        ? Colors.red
                        : status == "warning"
                        ? Colors.orange
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                title: const Text("Device State"),
                subtitle: Text(
                  deviceState,
                  style: TextStyle(
                    color: deviceState == "on"
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
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

                    const SizedBox(height: 10),

                    Text(
                      recommendation,
                      style: TextStyle(
                        color: deviceOff
                            ? Colors.green
                            : Colors.white,
                      ),
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