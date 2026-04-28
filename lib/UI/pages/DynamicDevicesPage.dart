import 'package:flutter/material.dart';
import '../../models/alert_model.dart';
import '../../services/alert_service.dart';
import '../widets/DeviceCard.dart';
import 'DashboardChartsPage.dart';

class DynamicDevicesPage extends StatefulWidget {
  final String roomName;
  final List<Map<String, dynamic>> devices;

  const DynamicDevicesPage({

    super.key,
    required this.roomName,
    required this.devices,
  });

  @override
  State<DynamicDevicesPage> createState() => _DynamicDevicesPageState();
}

class _DynamicDevicesPageState extends State<DynamicDevicesPage> {

  late List<Map<String, dynamic>> devices;

  /// ✅ FIX هنا
  String? selectedDevice;

  AlertModel? alert;
  double temperature = 26;
  double humidity = 35;

  @override
  void initState() {
    super.initState();
    devices = List.from(widget.devices);
    loadAlert();
  }

  void loadAlert() async {
    alert = await AlertService.fetchAlert();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.roomName),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, devices); // 👈 ده أهم سطر
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),

      body: Stack(
        children: [

          /// 🔥 BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "assets/images/living room decore.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// 🔥 OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          /// 🔥 CONTENT
          SafeArea(
            child: Column(
              children: [

                const SizedBox(height: 20),

                /// 🌡 SENSOR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sensorItem(Icons.thermostat, "$temperature°C", "Temp"),
                        _sensorItem(Icons.water_drop, "$humidity%", "Humidity"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 📦 DEVICES
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: devices.length,
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DeviceCard(

                          iconPath: devices[i]["icon"],
                          name: devices[i]["name"],
                          isOn: devices[i]["isOn"],
                          onToggle: (val) {
                            setState(() {
                              devices[i]["isOn"] = val;
                            });
                          },
                          onDelete: () {
                            setState(() {
                              devices.removeAt(i);
                            });
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {
          showAddDeviceDialog(context);
        },
      ),
    );
  }

  Widget _sensorItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }


  void showAddDeviceDialog(BuildContext context) {

    String? selectedDevice; // 👈 خليها local

    final List<Map<String, String>> deviceOptions = [
      {"name": "Lamp", "icon": "assets/images/lamp.png"},
      {"name": "TV", "icon": "assets/images/tv.png"},
      {"name": "Fan", "icon": "assets/images/fan2.png"},
      {"name": "Air Conditioner", "icon": "assets/images/smartac.png"},
      {"name": "Heater", "icon": "assets/images/heater.png"},
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),

              title: const Text(
                "Select Device",
                style: TextStyle(color: Colors.white),
              ),

              content: DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),

                hint: const Text(
                  "Choose device",
                  style: TextStyle(color: Colors.white70),
                ),

                value: selectedDevice,

                items: deviceOptions.map((device) {
                  return DropdownMenuItem(
                    value: device["name"],
                    child: Text(device["name"]!),
                  );
                }).toList(),

                onChanged: (value) {
                  setDialogState(() {
                    selectedDevice = value;
                  });
                },
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {

                    print("Selected: $selectedDevice"); // 🔥 debug

                    if (selectedDevice == null) return;

                    final deviceData = deviceOptions.firstWhere(
                          (d) => d["name"] == selectedDevice,
                    );

                    setState(() {
                      devices.add({
                        "name": deviceData["name"],
                        "icon": deviceData["icon"],
                        "isOn": false,
                      });
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

}