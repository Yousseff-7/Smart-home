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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDevices();
  }

  Future loadDevices() async {

    try {

      devices =
      await service.getDevices(
        widget.roomId,
      );

    } catch (e) {

      print(e);

    }

    setState(() {
      isLoading = false;
    });

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

              setState(() {

                device.state =
                val ? "on" : "off";

              });

            },

            onDelete: () async {

              await service.deleteDevice(
                device.id!,
              );

              loadDevices();

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

    TextEditingController controller =
    TextEditingController();

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          backgroundColor:
          const Color(0xFF1E1E1E),

          title: const Text(

            "Add Device",

            style: TextStyle(
              color: Colors.white,
            ),

          ),

          content: TextField(

            controller: controller,

            style: const TextStyle(
              color: Colors.white,
            ),

            decoration:
            InputDecoration(

              hintText:
              "Device Name",

              hintStyle:
              const TextStyle(
                color: Colors.white54,
              ),

              filled: true,

              fillColor:
              Colors.black26,

              border:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(12),

              ),

            ),

          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);

              },

              child: const Text(
                "Cancel",
              ),

            ),

            ElevatedButton(

              onPressed: () async {

                if(controller.text
                    .trim()
                    .isEmpty) return;

                DeviceModel device =
                DeviceModel(

                  name:
                  controller.text,

                  roomId:
                  widget.roomId,

                );

                await service.addDevice(
                  device,
                );

                Navigator.pop(context);

                loadDevices();

              },

              child:
              const Text("Add"),

            ),

          ],

        );

      },

    );

  }

}
String getDeviceImage(String name) {

  String device =
  name.toLowerCase();

  if(device.contains("lamp")) {

    return "assets/images/lamp.png";

  }

  else if(device.contains("tv")) {

    return "assets/images/tv.png";

  }

  else if(device.contains("fan")) {

    return "assets/images/fan2.png";

  }

  else if(device.contains("heater")) {

    return "assets/images/heater.png";

  }

  else if(device.contains("ac")) {

    return "assets/images/smartac.png";

  }

  return "assets/images/lamp.png";

}