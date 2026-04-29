import 'package:flutter/material.dart';
import '../../data/app_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: ValueListenableBuilder(
            valueListenable: AppData.roomDevices,

            builder: (context, rooms, _) {

              double totalPower = 0;
              int activeDevices = 0;

              rooms.forEach((room, devices) {
                for (var d in devices) {
                  if (d["isOn"] == true) {
                    totalPower += (d["power"] ?? 0);
                    activeDevices++;
                  }
                }
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Total Power",
                                style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 6),
                            Text(
                              "${totalPower.toStringAsFixed(1)} W",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Active Devices",
                                style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 6),
                            Text(
                              "$activeDevices",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}