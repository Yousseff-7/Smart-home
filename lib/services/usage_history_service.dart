import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsageHistoryService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://64.225.101.222:5000/api",
    ),
  );

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  /// جميع الأجهزة
  Future<List<dynamic>> getDevices(String roomId) async {
    String token = await getToken();

    Response response = await dio.get(

      "/devices/$roomId",

      options: Options(
        headers: {
          "Authorization": "bearer $token",
        },
      ),

    );

    return List<dynamic>.from(response.data);
  }

  Future<List<dynamic>> getRooms() async {
    String token = await getToken();

    Response response = await dio.get(

      "/rooms",

      options: Options(
        headers: {
          "Authorization": "bearer $token",
        },
      ),

    );

    return List<dynamic>.from(response.data);
  }

  /// جميع القراءات لكل الأجهزة
  Future<List<dynamic>> getHistory() async {
    List rooms = await getRooms();

    List allHistory = [];

    for (var room in rooms) {
      List devices = await getDevices(room["_id"]);

      for (var device in devices) {
        try {
          String token = await getToken();

          Response response = await dio.get(
            "/readings/device/${device["_id"]}",
            options: Options(
              headers: {
                "Authorization": "bearer $token",
              },
            ),
          );

          print("DEVICE = ${device["name"]}");
          print("TYPE = ${response.data.runtimeType}");
          print("BODY = ${response.data}");



          Map<String, dynamic> result =
          Map<String, dynamic>.from(response.data);

          List readings =
          List<dynamic>.from(result["readings"] ?? []);

          for (var reading in readings) {
            reading["deviceName"] = device["name"];
          }

          allHistory.addAll(readings);
        } catch (e) {
          print(e);
        }
      }
    }

    print("ROOMS = ${rooms.length}");
    print("TOTAL HISTORY = ${allHistory.length}");
    print(allHistory);
    allHistory.sort(
          (a, b) => DateTime.parse(b["createdAt"])
          .compareTo(
        DateTime.parse(a["createdAt"]),
      ),
    );
    if (allHistory.length > 50) {
      allHistory = allHistory.take(50).toList();
    }
    return allHistory;
  }
}