import 'package:flutter/material.dart';

import '../../models/device_model.dart';
import '../../services/device_service.dart';

import '../widets/DeviceCard.dart';

class DynamicDevicesPage extends StatefulWidget {

  final String roomId;
  final String roomName;

  const DynamicDevicesPage({

    super.key,

    required this.roomId,
    required this.roomName,

  });

  @override
  State<DynamicDevicesPage> createState() =>
      _DynamicDevicesPageState();
}

class _DynamicDevicesPageState
    extends State<DynamicDevicesPage> {

  final DeviceService service =
  DeviceService();

  List<DeviceModel> devices = [];
  final List<String> deviceNames = [

    "Smart TV",

    "Smart Lamp",

    "Smart Fan",

    "Smart Kettle",

    "Smart Microwave",

    "Smart Toaster",

    "Smart Coffee Maker",

    "Smart Speaker",

    "Smart Laptop Charger",

  ];

  bool isLoading = true;
  final List<Map<String, String>> deviceTypes = [

    {
      "name": "Smart TV",
      "image": "assets/images/tv.png",
    },

    {
      "name": "Smart Lamp",
      "image": "assets/images/lamp.png",
    },

    {
      "name": "Smart Fan",
      "image": "assets/images/fan2.png",
    },

    {
      "name": "Smart Kettle",
      "image": "assets/images/kettle.png",
    },

    {
      "name": "Smart Microwave",
      "image": "assets/images/microwave.png",
    },

    {
      "name": "Smart Toaster",
      "image": "assets/images/toaster.png",
    },

    {
      "name": "Smart Coffee Maker",
      "image": "assets/images/coffee.png",
    },

    {
      "name": "Smart Speaker",
      "image": "assets/images/speaker.png",
    },

    {
      "name": "Smart Laptop Charger",
      "image": "assets/images/charger.png",
    },

  ];

  @override
  void initState() {
    super.initState();

    print("ROOM ID = ${widget.roomId}");

    loadDevices();
  }
  Future loadDevices() async {

    try {

      devices =
      await service.getDevices(
        widget.roomId,
      );

      print("ROOM ID => ${widget.roomId}");
      print("DEVICES => $devices");

    } catch (e) {

      print(e);

    }

    setState(() {
      isLoading = false;
    });
  }
  void showEditDialog(DeviceModel device) {

    Map<String, String>? selected =
    deviceTypes.firstWhere(

          (e) => e["name"] == device.name,

      orElse: () => deviceTypes.first,

    );

    showDialog(

      context: context,

      builder: (_) {

        return StatefulBuilder(

          builder: (context, setDialog) {

            return AlertDialog(

              backgroundColor:
              const Color(0xFF1E1E1E),

              title: const Text(

                "Edit Device",

                style: TextStyle(
                  color: Colors.white,
                ),

              ),

              content: DropdownButtonFormField<Map<String, String>>(

                value: selected,

                dropdownColor:
                const Color(0xFF1E1E1E),

                style: const TextStyle(
                  color: Colors.white,
                ),

                items: deviceTypes.map((item) {

                  return DropdownMenuItem(

                    value: item,

                    child: Text(item["name"]!),

                  );

                }).toList(),

                onChanged: (value) {

                  setDialog(() {

                    selected = value;

                  });

                },

              ),

              actions: [

                TextButton(

                  onPressed: () {

                    Navigator.pop(context);

                  },

                  child: const Text("Cancel"),

                ),

                ElevatedButton(

                  onPressed: () async {

                    await service.updateDevice(

                      device.id!,

                      selected!["name"]!,

                      selected!["image"]!,

                    );

                    Navigator.pop(context);

                    loadDevices();

                  },

                  child: const Text("Save"),

                ),

              ],

            );

          },

        );

      },

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F0F0F),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        title: Text(
          widget.roomName,
        ),

      ),

      body:

      isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : devices.isEmpty

          ? const Center(

        child: Text(

          "No Devices",

          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),

        ),

      )

          : GridView.builder(

        padding:
        const EdgeInsets.all(16),

        itemCount: devices.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 2,

          crossAxisSpacing: 16,

          mainAxisSpacing: 16,

          childAspectRatio: 0.9,

        ),

        itemBuilder: (_, i) {

          DeviceModel device =
          devices[i];

          return DeviceCard(

            deviceId: device.id!,

            iconPath: getDeviceImage(device.name),

            name: device.name,

            isOn: device.state == "on",

            onToggle: (val) async {

              await service.updateState(
                device.id!,
                val ? "on" : "off",
              );

            }, onEdit: () {

            showEditDialog(device);

          },

              onDelete: () {

              },

          );
        },

      ),

      floatingActionButton:
      FloatingActionButton(

        backgroundColor:
        Colors.orange,

        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),

        onPressed: () {

          showAddDialog();

        },

      ),

    );

  }

  void showAddDialog() {

    String? selectedDevice;

    showDialog(

      context: context,

      builder: (_) {

        return StatefulBuilder(

          builder: (context, setDialog) {

            return AlertDialog(

              backgroundColor: const Color(0xFF1E1E1E),

              title: const Text(

                "Add Device",

                style: TextStyle(
                  color: Colors.white,
                ),

              ),

              content: DropdownButtonFormField<String>(

                value: selectedDevice,

                dropdownColor: const Color(0xFF1E1E1E),

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  filled: true,

                  fillColor: Colors.black26,

                  border: OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(12),

                  ),

                ),

                hint: const Text(

                  "Choose Device",

                  style: TextStyle(
                    color: Colors.white54,
                  ),

                ),

                items: deviceNames.map((device) {

                  return DropdownMenuItem(

                    value: device,

                    child: Text(device),

                  );

                }).toList(),

                onChanged: (value) {

                  setDialog(() {

                    selectedDevice = value;

                  });

                },

              ),
              
              
              

              actions: [

                TextButton(

                  onPressed: () {

                    Navigator.pop(context);

                  },

                  child: const Text("Cancel"),

                ),

                ElevatedButton(

                  onPressed: () async {

                    if (selectedDevice == null) return;

                    DeviceModel device = DeviceModel(

                      name: selectedDevice!,

                      roomId: widget.roomId,

                    );

                    await service.addDevice(device);

                    Navigator.pop(context);

                    loadDevices();

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
String getDeviceImage(String name) {

  String device = name.toLowerCase();

  if (device.contains("lamp")) {
    return "assets/images/lamp.png";
  }

  if (device.contains("tv")) {
    return "assets/images/tv.png";
  }

  if (device.contains("fan")) {
    return "assets/images/fan2.png";
  }

  if (device.contains("kettle")) {
    return "assets/images/kettle.png";
  }

  if (device.contains("microwave")) {
    return "assets/images/microwave.png";
  }

  if (device.contains("toaster")) {
    return "assets/images/toaster.png";
  }

  if (device.contains("coffee")) {
    return "assets/images/coffee.png";
  }

  if (device.contains("speaker")) {
    return "assets/images/speaker.png";
  }

  if (device.contains("charger")) {
    return "assets/images/charger.png";
  }

  return "assets/images/lamp.png";

}