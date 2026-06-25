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

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.08),

            blurRadius: 10,

            offset: const Offset(0, 4),

          ),

        ],

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

                      style: TextStyle(

                        color: Theme.of(context)
                            .colorScheme
                            .onSurface,

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                    Text(

                      weather.condition,

                      style: TextStyle(

                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color,

                      ),

                    ),

                  ],

                ),

              ),

              Text(

                "${weather.temperature.toStringAsFixed(0)}°C",

                style: TextStyle(

                  color: Theme.of(context)
                      .colorScheme
                      .onSurface,

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

                style: TextStyle(

                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color,

                ),

              ),

              Text(

                "🌬 ${weather.wind.toStringAsFixed(0)} km/h",

                style: TextStyle(

                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color,

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}