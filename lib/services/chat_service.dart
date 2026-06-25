import 'package:dio/dio.dart';

class ChatService {

  final Dio dio = Dio();

  Future<String> sendMessage(
      String message) async {

    try {

      Response response =
      await dio.post(

        "http://64.225.101.222:5000/api/chat",

        data: {
          "message": message,
        },

      );

      return response.data["reply"];

    } catch (e) {

      print(e);

      return "Error";
    }
  }
}