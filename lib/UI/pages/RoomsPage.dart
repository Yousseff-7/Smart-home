import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widets/RoomCard.dart';
import 'DynamicDevicesPage.dart';
import 'Setting_Page.dart';
import '../../data/app_data.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  void loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String savedName = prefs.getString("name") ?? '';

    setState(() {
      username = savedName;
    });
  }

  final List<Map<String, dynamic>> rooms = [
    {'title': 'Living Room', 'image': 'assets/images/living room decore.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    double totalPower = 0;
    int activeDevices = 0;
    int roomsNumber = rooms.length;
    int devicesNumber = 0;

    /// 🔥 حساب البيانات من AppData
    AppData.roomDevices.value.forEach((room, devices) {
      devicesNumber += devices.length;
      for (var d in devices) {
        if (d["isOn"] == true) {
          totalPower += (d["power"] ?? 0);
          activeDevices++;
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Smart Home",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.person, color: Colors.white),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => ProfilePage(
          //           roomsNumber: roomsNumber,
          //           devicesNumber: devicesNumber,
          //         ),
          //       ),
          //     );
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome back 👋",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 5),

            Text(
              username,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            const SizedBox(height: 30),

            const Text(
              "Your Rooms",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            /// 🔥 Grid Rooms
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: rooms.map((room) {
                String title = room['title'];

                return RoomCard(
                  title: title,
                  subtitle:
                      "Devices: ${AppData.roomDevices.value[title]?.length ?? 0}",
                  imageUrl: room['image'],
                  onTap: () async {
                    final updatedDevices = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DynamicDevicesPage(
                          roomName: title,
                          devices: AppData.roomDevices.value[title]!,
                        ),
                      ),
                    );

                    if (updatedDevices != null) {
                      AppData.roomDevices.value[title] = updatedDevices;

                      /// 🔥 أهم سطر
                      AppData.roomDevices.notifyListeners();
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),

      /// 🔥 Add Room Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF59E0B),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          showAddRoomDialog(context);
        },
      ),
    );
  }

  /// 🔥 Dialog إضافة Room
  void showAddRoomDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Add New Room",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),

          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black),

            decoration: InputDecoration(
              hintText: "Enter room name",
              hintStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.orange),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
              ),
              onPressed: () async {
                String name = controller.text.trim();
                final prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString("token");
                if (name.isNotEmpty) {
                  await Dio().post(
                    "http://64.225.101.222:5000/api/rooms",
                    data: {"name": name},
                    options: Options(headers: {"Authorization": "Bearer $token"}),
                  );

                  setState(() {
                    rooms.add({
                      'title': name,
                      'image': 'assets/images/living room decore.jpg',
                    });
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Add", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
