import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutomationPage extends StatefulWidget {
  const AutomationPage({super.key});

  @override
  State<AutomationPage> createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage> {
  String? selectedDeviceId;

  List devices = [];
  List schedules = [];
  String selectedAction = "Turn OFF";
  String selectedRepeat = "Daily";
  TimeOfDay? selectedTime;





  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
  @override
  void initState() {
    super.initState();

    loadDevices();
    loadSchedules();
  }
  Future loadDevices() async {

    final prefs =
    await SharedPreferences.getInstance();

    String token =
        prefs.getString("token") ?? "";

    try {

      Response roomsResponse =
      await Dio().get(

        "http://64.225.101.222:5000/api/rooms",

        options: Options(
          headers: {
            "Authorization":
            "bearer $token",
          },
        ),
      );

      List rooms =
          roomsResponse.data;

      List allDevices = [];

      for (var room in rooms) {

        Response deviceResponse =
        await Dio().get(

          "http://64.225.101.222:5000/api/devices/${room["_id"]}",

          options: Options(
            headers: {
              "Authorization":
              "bearer $token",
            },
          ),
        );

        for (var device in deviceResponse.data) {

          device["roomName"] =
          room["name"];

          allDevices.add(device);

        }
      }

      setState(() {

        devices = allDevices;

      });

    } catch (e) {

      print(e);

    }
  }

  Future addSchedule() async {

    if (selectedDeviceId == null ||
        selectedTime == null) {
      return;
    }

    final prefs =
    await SharedPreferences.getInstance();

    String token =
        prefs.getString("token") ?? "";

    try {

      await Dio().post(

        "http://64.225.101.222:5000/api/schedules",

        data: {

          "deviceId":
          selectedDeviceId,

          "action":
          selectedAction ==
              "Turn OFF"
              ? "off"
              : "on",

          "time":
          "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",

          "repeatType":
          selectedRepeat.toLowerCase(),

        },

        options: Options(
          headers: {
            "Authorization":
            "bearer $token",
          },
        ),
      );

      await loadSchedules();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Schedule Added"),
          backgroundColor:
          Colors.green,
        ),
      );

    } catch (e) {

      print(e);

    }
  }
  Future loadSchedules() async {

    final prefs =
    await SharedPreferences.getInstance();

    String token =
        prefs.getString("token") ?? "";

    try {

      Response response =
      await Dio().get(

        "http://64.225.101.222:5000/api/schedules",

        options: Options(
          headers: {
            "Authorization":
            "bearer $token",
          },
        ),
      );

      setState(() {

        schedules =
            response.data;

      });

    } catch (e) {

      print(e);

    }
  }
  Future deleteSchedule(
      String scheduleId) async {

    final prefs =
    await SharedPreferences.getInstance();

    String token =
        prefs.getString("token") ?? "";

    try {

      await Dio().delete(

        "http://64.225.101.222:5000/api/schedules/$scheduleId",

        options: Options(
          headers: {
            "Authorization":
            "bearer $token",
          },
        ),
      );

      await loadSchedules();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Schedule Deleted",
          ),

          backgroundColor:
          Colors.red,

        ),

      );

    } catch (e) {

      print(e);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Delete Failed",
          ),

        ),

      );
    }
  }
  Future showEditDialog(
      Map schedule) async {

    String action =
    schedule["action"];

    String repeatType =
    schedule["repeatType"];

    TextEditingController timeController =
    TextEditingController(
      text: schedule["time"],
    );

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            "Edit Schedule",
          ),

          content: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              TextField(

                controller:
                timeController,

                decoration:
                const InputDecoration(
                  labelText: "Time",
                ),

              ),

              const SizedBox(height: 15),

              DropdownButtonFormField(

                value: action,

                items: const [

                  DropdownMenuItem(
                    value: "on",
                    child: Text("ON"),
                  ),

                  DropdownMenuItem(
                    value: "off",
                    child: Text("OFF"),
                  ),

                ],

                onChanged: (value) {

                  action =
                      value.toString();

                },

              ),

              const SizedBox(height: 15),

              DropdownButtonFormField(

                value: repeatType,

                items: const [

                  DropdownMenuItem(
                    value: "daily",
                    child: Text("Daily"),
                  ),

                  DropdownMenuItem(
                    value: "weekly",
                    child: Text("Weekly"),
                  ),

                  DropdownMenuItem(
                    value: "once",
                    child: Text("Once"),
                  ),

                ],

                onChanged: (value) {

                  repeatType =
                      value.toString();

                },

              ),
            ],
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                );

              },

              child: const Text(
                "Cancel",
              ),

            ),

            ElevatedButton(

              onPressed: () async {

                final prefs =
                await SharedPreferences.getInstance();

                String token =
                    prefs.getString("token") ?? "";

                try {

                  await Dio().put(

                    "http://64.225.101.222:5000/api/schedules/${schedule["_id"]}",

                    data: {

                      "action": action,

                      "time": timeController.text,

                      "repeatType": repeatType,

                    },

                    options: Options(
                      headers: {

                        "Authorization":
                        "bearer $token",

                      },
                    ),
                  );

                  Navigator.pop(context);

                  await loadSchedules();

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(

                      content: Text(
                        "Schedule Updated",
                      ),

                      backgroundColor:
                      Colors.green,

                    ),

                  );

                } catch (e) {

                  print(e);

                }

              },
              child: const Text(
                "Save",
              ),

            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Automation",
          style: TextStyle(
            color: Theme.of(context)
                .textTheme
                .titleLarge
                ?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white12,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    "New Schedule",
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(
                              "DEVICE",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                              ),
                            ),

                            const SizedBox(height: 10),

                            DropdownButtonFormField<String>(
                              value: selectedDeviceId,
                              dropdownColor: Theme.of(context).cardColor,

                              decoration: inputDecoration(),

                              items: devices.map<DropdownMenuItem<String>>((device) {

                                return DropdownMenuItem<String>(

                                  value: device["_id"].toString(),

                                  child: Text(
                                    "${device["roomName"]} - ${device["name"]}",
                                  ),

                                );

                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  selectedDeviceId = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                             Text(
                              "ACTION",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                              ),
                            ),

                            const SizedBox(height: 10),

                            DropdownButtonFormField(
                              value: selectedAction,

                              dropdownColor:
                               Colors.white24,

                              decoration: inputDecoration(),

                              items: const [
                                DropdownMenuItem(
                                  value: "Turn ON",
                                  child: Text("Turn ON"),
                                ),
                                DropdownMenuItem(
                                  value: "Turn OFF",
                                  child: Text("Turn OFF"),
                                ),
                              ],

                              onChanged: (value) {
                                setState(() {
                                  selectedAction =
                                      value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                             Text(
                              "TIME",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ),
                            ),

                            const SizedBox(height: 10),

                            GestureDetector(
                              onTap: pickTime,

                              child: Container(
                                height: 58,

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                                  border: Border.all(
                                    color: Colors.white24,
                                  ),
                                ),

                                child: Row(
                                  children: [

                                    Expanded(
                                      child: Text(
                                        selectedTime == null
                                            ? "--:--"
                                            : selectedTime!
                                            .format(
                                          context,
                                        ),
                                        style:
                                        TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.color,
                                        )
                                      ),
                                    ),

                                     Icon(
                                      Icons.access_time,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                             Text(
                              "REPEAT",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                              ),
                            ),

                            const SizedBox(height: 10),

                            DropdownButtonFormField(
                              value: selectedRepeat,

                              dropdownColor:
                              Colors.white24,

                              decoration: inputDecoration(),

                              items: const [
                                DropdownMenuItem(
                                  value: "Daily",
                                  child: Text("Daily"),
                                ),
                                DropdownMenuItem(
                                  value: "Weekly",
                                  child: Text("Weekly"),
                                ),
                                DropdownMenuItem(
                                  value: "Once",
                                  child: Text("Once"),
                                ),
                              ],

                              onChanged: (value) {
                                setState(() {
                                  selectedRepeat =
                                      value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: 220,
                    height: 55,

                    child: ElevatedButton.icon(
                      onPressed: () async {

                        await addSchedule();

                      },

                      icon: const Icon(Icons.add),

                      label: const Text(
                        "Add Schedule",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.orange,
                        foregroundColor: Colors.black,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Your Schedules",
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.color,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...schedules.map(
                  (schedule) => Card(
                    color: Theme.of(context).cardColor,

                child: ListTile(
                  title: Text(
                    schedule["deviceId"]["name"],
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.color,
                    ),
                  ),

                  subtitle: Text(
                    "${schedule["action"]} • ${schedule["time"]} • ${schedule["repeatType"]}",
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color,
                    ),
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      IconButton(

                        icon: const Icon(
                          Icons.edit,
                          color: Colors.orange,
                        ),

                        onPressed: () {

                          showEditDialog(
                            schedule,
                          );

                        },
                      ),

                      IconButton(

                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),

                        onPressed: () {

                          showDialog(

                            context: context,

                            builder: (context) {

                              return AlertDialog(

                                backgroundColor:
                                Theme.of(context).cardColor,

                                title: Text(

                                  "Delete Schedule",

                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                content: Text(

                                  " Do you want to continue?",

                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                ),

                                actions: [

                                  TextButton(

                                    onPressed: () {

                                      Navigator.pop(
                                        context,
                                      );

                                    },

                                    child: const Text(
                                      "Cancel",
                                    ),
                                  ),

                                  ElevatedButton(

                                    style:
                                    ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Colors.red,
                                    ),

                                    onPressed: () async {

                                      Navigator.pop(
                                        context,
                                      );

                                      await deleteSchedule(
                                        schedule["_id"],
                                      );

                                    },

                                    child: const Text(
                                      "Delete",
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor:  Colors.orange,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}