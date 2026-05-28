import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/room_model.dart';

class RoomService {

  final Dio dio = Dio(

    BaseOptions(

      baseUrl:
      "http://64.225.101.222:5000/api",

      connectTimeout:
      const Duration(seconds: 10),

      receiveTimeout:
      const Duration(seconds: 10),

    ),

  );

  Future<String> getToken() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString("token") ?? "";

  }

  Future<List<RoomModel>> getRooms() async {

    try {

      String token =
      await getToken();

      Response response =
      await dio.get(

        "/rooms",

        options: Options(

          headers: {

            "Authorization":
            "bearer $token",

          },

        ),

      );

      List rooms =
          response.data;

      return rooms.map(

            (e)=>

            RoomModel.fromJson(e),

      ).toList();

    }

    on DioException catch(e){

      print(
        "GET ERROR = "
            "${e.response?.data}",
      );

      return [];

    }

  }

  Future addRoom(
      RoomModel room,
      Uint8List? imageBytes,
      ) async {

    String token = await getToken();

    await dio.post(

      "/rooms",

      data: {

        "name": room.name,

      },

      options: Options(

        headers: {

          "Authorization":
          "bearer $token",

        },

      ),

    );

  }
  Future deleteRoom(
      String id
      ) async {

    try {

      String token =
      await getToken();

      await dio.delete(

        "/rooms/$id",

        options: Options(

          headers: {

            "Authorization":
            "bearer $token",

          },

        ),

      );

      print(
        "ROOM DELETED",
      );

    }

    on DioException catch(e){

      print(
        "DELETE ERROR = "
            "${e.response?.data}",
      );

    }

  }

  Future updateRoom(

      RoomModel room,

      Uint8List? imageBytes,

      ) async {

    try {

      String token =
      await getToken();

      FormData formData =
      FormData.fromMap({

        "name":
        room.name,

        if(imageBytes != null)

          "image":

          MultipartFile.fromBytes(

            imageBytes,

            filename:
            "room.jpg",

          ),

      });

      await dio.put(

        "/rooms/${room.id}",

        data:
        formData,

        options: Options(

          headers: {

            "Authorization":
            "bearer $token",

            "Content-Type":
            "multipart/form-data",

          },

        ),

      );

      print(
        "ROOM UPDATED",
      );

    }

    on DioException catch(e){

      print(
        "UPDATE ERROR = "
            "${e.response?.data}",
      );

    }

  }

}