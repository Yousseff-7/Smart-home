import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ai_prediction_model.dart';

class AIService {

  final Dio dio = Dio();

  Future<AIPredictionModel?> getPrediction(
      String deviceId) async {

    try {

      final prefs =
      await SharedPreferences.getInstance();

      String token =
          prefs.getString("token") ?? "";

      Response response = await dio.get(

        "http://64.225.101.222:5000/api/readings/$deviceId",

        options: Options(

          headers: {

            "Authorization":
            "bearer $token",

          },

        ),

      );

      print(response.data);

      final latest =
      response.data["latestReading"];

      if (latest == null) return null;

      final ai =
      latest["aiPrediction"];

      if (ai == null) return null;
      print(ai);
      return AIPredictionModel.fromJson(ai);

    } catch (e) {

      print(e);

      return null;

    }

  }


  Future<String> getStatus(
      String deviceId) async {

    try {

      final prediction =
      await getPrediction(deviceId);

      return prediction?.status ??
          "normal";

    } catch (e) {

      return "normal";

    }

  }

}