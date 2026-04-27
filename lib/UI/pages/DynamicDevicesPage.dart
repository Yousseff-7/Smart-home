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

  AlertModel? alert;
  bool isLoadingAlert = true;

  /// 🔥 Sensor data (مؤقت لحد API)
  double temperature = 26;
  double humidity = 35;

  @override
  void initState() {
    super.initState();
    devices = widget.devices;
    loadAlert();
  }

  void loadAlert() async {
    alert = await AlertService.fetchAlert();

    setState(() {
      isLoadingAlert = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.roomName),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),

      body: Stack(
        children: [
          /// 📸 BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "assets/images/living room decore.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// 🌑 OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          /// 🧠 CONTENT
          Column(
            children: [
              const SizedBox(height: 100),

              /// 🔔 ALERT
              if (alert != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: alert!.status == "warning"
                        ? Colors.orange.withOpacity(0.15)
                        : Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: alert!.status == "warning"
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        alert!.status == "warning"
                            ? Icons.warning
                            : Icons.check_circle,
                        color: alert!.status == "warning"
                            ? Colors.orange
                            : Colors.green,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          alert!.recommendation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              /// 🌡 SENSOR SECTION
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
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

              const SizedBox(height: 12),

              /// 📦 DEVICES
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),

                  child: GridView.builder(
                    itemCount: devices.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DashboardChartsPage(
                                currentValues: [1, 2, 3, 2, 4, 5, 3],
                                voltageValues: [220, 221, 223, 222, 224, 225, 223],
                                powerValues: [40, 50, 45, 60, 55, 70, 65],
                              ),
                            ),
                          );
                        },
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
                ),
              ),
            ],
          ),
        ],
      ),

      /// ➕ FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {
          showAddDeviceDialog(context);
        },
      ),
    );
  }

  /// 🌡 SENSOR ITEM
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

  /// ➕ ADD DEVICE DIALOG
  void showAddDeviceDialog(BuildContext context) {
    String? selectedDevice;

    final List<Map<String, String>> deviceOptions = [
      {"name": "Lamp", "icon": "assets/images/lamp.png"},
      {"name": "TV", "icon": "assets/images/tv.png"},
      {"name": "Fan", "icon": "assets/images/fan2.png"},
      {"name": "Air Conditioner", "icon": "assets/images/smartac.png"},
      {"name": "Heater", "icon": "assets/images/heater.png"},
    ];

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              title: const Text("Select Device",
                  style: TextStyle(color: Colors.white)),

              content: DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                hint: const Text("Choose device",
                    style: TextStyle(color: Colors.white70)),
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.orange)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedDevice != null) {
                      var deviceData = deviceOptions.firstWhere(
                              (d) => d["name"] == selectedDevice);

                      setState(() {
                        devices.add({
                          "name": deviceData["name"],
                          "icon": deviceData["icon"],
                          "isOn": false,
                        });
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
      },
    );
  }
}