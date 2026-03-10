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

  Map<String, List<Map<String, dynamic>>> roomDevices = {"Living Room": []};

  @override
  Widget build(BuildContext context) {
    double totalPower = 0;
    int activeDevices = 0;
    int roomsNumber = rooms.length;
    int devicesNumber = 0;
    roomDevices.forEach((room, devices) {
      devicesNumber += devices.length;
      for (var d in devices) {
        if (d["isOn"] == false) {
          totalPower += (d["power"] ?? 0);
          activeDevices++;
          setState(() {
            activeDevices = activeDevices;
          });
        }
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Smart Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF1A2235),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF1A2235)),
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
            icon: const Icon(Icons.settings, color: Color(0xFF1A2235)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FB), Color(0xFFE4E9F2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 110, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Welcome
              Text(
                "Welcome back 👋",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 5),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2235),
                ),
              ),
              const SizedBox(height: 30),

              /// Dashboard
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A2235), Color(0xFF2C3E70)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Power",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${totalPower.toStringAsFixed(1)} W",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ), // space taken by the divider

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Active Devices",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$activeDevices",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              const Text(
                "Your Rooms",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2235),
                ),
              ),
              const SizedBox(height: 16),

              /// GridView
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
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DynamicDevicesPage(
                            roomName: title,
                            devices: roomDevices[title]!,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: const Color(0xFF1A2235),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
        onPressed: () {
          showAddRoomDialog(context);
        },
      ),
    );
  }

  void showAddRoomDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Add New Room",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter room name",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A2235),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                String name = controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    rooms.add({
                      'title': name,
                      'image': 'assets/images/living room decore.jpg',
                    });
                    roomDevices[name] = [];
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
