import 'package:flutter/material.dart';
import '../widets/DeviceCard.dart';

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

  @override
  void initState() {
    super.initState();
    devices = widget.devices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor
      ,
      appBar: AppBar(
        title: Text(widget.roomName),
        backgroundColor: Colors.black,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: devices.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (_, i) {
          return DeviceCard(
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
          );

        },
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
              title: const Text("Select Device"),
              content: DropdownButtonFormField<String>(
                hint: const Text("Choose device"),
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
                  child: const Text("Cancel"),
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
