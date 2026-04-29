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
              int roomsCount = rooms.length;

              /// 🔥 حساب البيانات
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

                  /// 🔝 Title
                  const Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// 🔥 3 Cards Row
                  Row(
                    children: [

                      Expanded(
                        child: _statusCard(
                          title: "Power",
                          value: "${totalPower.toStringAsFixed(1)} W",
                          icon: Icons.bolt,
                          color: Colors.orange,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _statusCard(
                          title: "Devices",
                          value: "$activeDevices",
                          icon: Icons.devices,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _statusCard(
                          title: "Rooms",
                          value: "$roomsCount",
                          icon: Icons.home,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 Quick Actions (اختياري بس شكلها جامد)
                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          "All Off",
                          Icons.power_off,
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _actionButton(
                          "All On",
                          Icons.power,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🔹 Status Card
  Widget _statusCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),

          const SizedBox(height: 12),

          /// Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Quick Action Button
  Widget _actionButton(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}