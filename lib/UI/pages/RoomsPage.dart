import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled55/UI/pages/Profile_Page.dart';
import '../widets/RoomCard.dart';
import 'DynamicDevicesPage.dart';
import 'Setting_Page.dart';

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

  Map<String, List<Map<String, dynamic>>> roomDevices = {
    "Living Room": []
  };

  @override
  Widget build(BuildContext context) {
    double totalPower = 0;
    int activeDevices = 0;
    int roomsNumber = rooms.length;
    int devicesNumber = 0;

    roomDevices.forEach((room, devices) {
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    roomsNumber: roomsNumber,
                    devicesNumber: devicesNumber,
                  ),
                ),
              );
            },
          ),
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

            /// Dashboard Card
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
                  subtitle: "Devices: ${roomDevices[title]?.length ?? 0}",
                  imageUrl: room['image'],
                  onTap: () async {
                    final updatedDevices = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DynamicDevicesPage(
                          roomName: title,
                          devices: roomDevices[title]!,
                        ),
                      ),
                    );

                    if (updatedDevices != null) {
                      setState(() {
                        roomDevices[title] = updatedDevices;
                      });
                    }
                    setState(() {});
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF59E0B),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          showAddRoomDialog(context);
        },
      ),
    );
  }

  /// 🔥 UPDATED DIALOG
  void showAddRoomDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white, // 👈 مهم

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Add New Room",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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

                if (name.isNotEmpty) {
                  setState(() {
                    rooms.add({
                      'title': name,
                      'image':
                      'assets/images/living room decore.jpg',
                    });
                    roomDevices[name] = [];
                  });
                }

                Navigator.pop(context);
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}