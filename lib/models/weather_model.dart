class WeatherModel {

  final String city;
  final String condition;

  final double temperature;
  final int humidity;

  final double wind;

  WeatherModel({

    required this.city,
    required this.condition,

    required this.temperature,
    required this.humidity,

    required this.wind,
  });

  factory WeatherModel.fromJson(
      Map<String, dynamic> json) {

    return WeatherModel(

      city:
      json["location"]["name"],

      condition:
      json["current"]["condition"]["text"],

      temperature:
      json["current"]["temp_c"]
          .toDouble(),

      humidity:
      json["current"]["humidity"],

      wind:
      json["current"]["wind_kph"]
          .toDouble(),
    );
  }
}