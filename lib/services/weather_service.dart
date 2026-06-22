import 'package:dio/dio.dart';

import '../models/weather_model.dart';

class WeatherService {

  Future<WeatherModel> getWeather() async {

    Response response =
    await Dio().get(

      "https://api.weatherapi.com/v1/current.json",

      queryParameters: {

        "key":
        "cdd9dfbba5f14c9ea28215538250709",

        "q":
        "Cairo",
      },
    );

    return WeatherModel.fromJson(
      response.data,
    );
  }
}