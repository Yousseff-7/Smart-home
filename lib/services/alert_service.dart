import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/alert_model.dart';

class AlertService {
  static final Dio dio = Dio();

  static Future<AlertModel?> fetchAlert() async {
    try {
      final response = await dio.get("http://10.0.2.2:8000/alert");

      if (response.statusCode == 200) {
        final data = response.data;
        return AlertModel.fromJson(data);
      }
    } catch (e) {
      print("API ERROR: $e");
    }

    return null;
  }
}