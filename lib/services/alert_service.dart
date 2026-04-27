import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alert_model.dart';

class AlertService {

  static Future<AlertModel?> fetchAlert() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/alert"), // مهم مش localhost
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AlertModel.fromJson(data);
      }
    } catch (e) {
      print("API ERROR: $e");
    }

    return null;
  }
}