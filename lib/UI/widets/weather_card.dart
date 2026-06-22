import 'package:flutter/material.dart';

import '../../models/weather_model.dart';

class WeatherCard extends StatelessWidget {

  final WeatherModel weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color:
        const Color(0xFF1E1E1E),

        borderRadius:
        BorderRadius.circular(20),

      ),

      child: Column(

        children: [

          Row(

            children: [

              const Icon(
                Icons.wb_sunny,
                color: Colors.orange,
                size: 35,
              ),

              const SizedBox(width: 12),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      weather.city,

                      style:
                      const TextStyle(

                        color: Colors.white,

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,

                      ),
                    ),

                    Text(

                      weather.condition,

                      style:
                      const TextStyle(

                        color:
                        Colors.white70,

                      ),
                    ),
                  ],
                ),
              ),

              Text(

                "${weather.temperature.toStringAsFixed(0)}°C",

                style:
                const TextStyle(

                  color: Colors.white,

                  fontSize: 28,

                  fontWeight:
                  FontWeight.bold,

                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceAround,

            children: [

              Text(

                "💧 ${weather.humidity}%",

                style:
                const TextStyle(
                  color: Colors.white,
                ),
              ),

              Text(

                "🌬 ${weather.wind.toStringAsFixed(0)} km/h",

                style:
                const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}