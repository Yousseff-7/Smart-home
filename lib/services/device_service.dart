import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/device_model.dart';

class DeviceService {

  final Dio dio = Dio(

    BaseOptions(
      baseUrl: "http://64.225.101.222:5000/api",
    ),

  );

  Future<String> getToken() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString("token") ?? "";

  }

  Future<List<DeviceModel>> getDevices(
      String roomId,
      ) async {

    String token = await getToken();

    Response response = await dio.get(

      "/devices/$roomId",

      options: Options(

        headers: {

          "Authorization":
          "bearer $token",

        },

      ),

    );

    print("ROOM ID => $roomId");
    print("DEVICES => ${response.data}");

    List data = response.data;

    return data
        .map(
          (e) => DeviceModel.fromJson(e),
    )
        .toList();
  }

  Future addDevice(
      DeviceModel device,
      ) async {

    String token = await getToken();

    await dio.post(

      "/devices",

      data: device.toJson(),

      options: Options(

        headers: {

          "Authorization":
          "bearer $token",

        },

      ),

    );

  }

  Future deleteDevice(
      String id,
      ) async {

    String token = await getToken();

    await dio.delete(

      "/devices/$id",

      options: Options(

        headers: {

          "Authorization":
          "bearer $token",

        },

      ),

    );

  }

  Future updateDevice(
      String id,
      String name,
      String image,
      ) async {

    String token = await getToken();

    await dio.put(

      "/devices/$id",

      data: {

        "name": name,
        "image": image,

      },

      options: Options(

        headers: {

          "Authorization": "bearer $token",

        },

      ),

    );

  }
  Future updateState(
      String id,
      String state,
      ) async {

    String token = await getToken();

    await dio.put(

      "/devices/$id/state",

      data: {

        "state": state,

      },

      options: Options(

        headers: {

          "Authorization": "bearer $token",

        },

      ),

    );

  }
  Future<List<dynamic>> getAllDevices() async {

    String token = await getToken();

    Response response = await dio.get(

      "/devices",

      options: Options(

        headers: {
          "Authorization": "bearer $token",
        },

      ),

    );

    return List<dynamic>.from(response.data);

  }
}