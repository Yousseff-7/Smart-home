import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/device_model.dart';
import '../../models/room_model.dart';
import '../../models/weather_model.dart';

import '../../services/device_service.dart';
import '../../services/room_service.dart';
import '../../services/weather_service.dart';

import '../widets/weather_card.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RoomService roomService = RoomService();

  final DeviceService deviceService = DeviceService();

  final WeatherService weatherService = WeatherService();

  WeatherModel? weather;

  bool isLoading = true;

  int roomsCount = 0;

  int devicesCount = 0;

  double totalPower = 0;
  String userName = "";
  List<DeviceModel> allDevices = [];

  @override
  void initState() {
    super.initState();
    loadUserName();
    loadData();

    loadWeather();
  }

  Future loadData() async {
    try {
      List<RoomModel> rooms =
      await roomService.getRooms();

      roomsCount = rooms.length;

      allDevices.clear();

      for (var room in rooms) {
        List<DeviceModel> devices =
        await deviceService.getDevices(
          room.id!,
        );

        allDevices.addAll(devices);
      }

      devicesCount = allDevices.length;

      totalPower = allDevices
          .where(
            (e) => e.state == "on",
      )
          .length *
          10;

      weather =
      await weatherService.getWeather();
    } catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> loadUserName() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {

      userName = prefs.getString("name") ?? "User";

    });

  }
  Future<void> loadWeather() async {
    try {
      WeatherModel result =
      await weatherService.getWeather();

      print("CITY = ${result.city}");

      print("TEMP = ${result.temperature}");

      if (mounted) {
        setState(() {
          weather = result;
        });
      }
    } catch (e) {
      print("WEATHER ERROR");

      print(e);
    }
  }
  Future<void> turnAllOff() async {

    try {

      final prefs =
      await SharedPreferences.getInstance();

      String token =
          prefs.getString("token") ?? "";

      final dio = Dio();

      /// ================= GET ROOMS =================

      Response roomsResponse =
      await dio.get(

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

      /// ================= LOOP ROOMS =================

      for(var room in rooms){

        String roomId =
        room["_id"];

        /// ================= GET DEVICES =================

        Response devicesResponse =
        await dio.get(

          "http://64.225.101.222:5000/api/devices/$roomId",

          options: Options(

            headers: {

              "Authorization":
              "bearer $token",

            },

          ),

        );

        List devices =
            devicesResponse.data;

        /// ================= TURN OFF =================

        for(var device in devices){

          String deviceId =
          device["_id"];

          await dio.put(

            "http://64.225.101.222:5000/api/devices/$deviceId/state",

            data: {

              "state": "off",

            },

            options: Options(

              headers: {

                "Authorization":
                "bearer $token",

              },

            ),

          );

        }

      }

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          behavior: SnackBarBehavior.floating,

          margin: const EdgeInsets.all(20),

          elevation: 10,

          backgroundColor:

          Theme.of(context).brightness ==
              Brightness.dark

              ? const Color(0xFF1E1E1E)

              : Colors.white,

          shape: RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(18),

          ),

          content: Row(

            children: [

              Container(

                padding:
                const EdgeInsets.all(8),

                decoration: BoxDecoration(

                  color: Colors.green
                      .withOpacity(.15),

                  shape: BoxShape.circle,

                ),

                child: const Icon(

                  Icons.check_circle,

                  color: Colors.green,

                  size: 22,

                ),

              ),

              const SizedBox(width: 12),

              Expanded(

                child: Text(

                  "All devices turned off successfully",

                  style: TextStyle(

                    color:
                    Theme.of(context)
                        .colorScheme
                        .onSurface,

                    fontWeight:
                    FontWeight.w600,

                  ),

                ),

              ),

            ],

          ),

          duration:
          const Duration(seconds: 2),

        ),

      );

    } catch(e){

      print(e);

    }

  }




  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final width = size.width;

    final isMobile = width < 600;

    final isTablet = width >= 600 && width < 1000;

    final horizontalPadding =
    isMobile ? 20.0 : isTablet ? 28.0 : 40.0;

    final gridCount =
    isMobile ? 2 : isTablet ? 3 : 4;

    final weatherSpacing =
    isMobile ? 20.0 : 28.0;

    return Scaffold(

      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,

      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.orange,

        child: const Icon(

          Icons.smart_toy,

          color: Colors.black,

        ),

        onPressed: () {

          Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) => const ChatPage(),

            ),

          );

        },

      ),

      body: isLoading

          ? const Center(

        child: CircularProgressIndicator(),

      )

          : SafeArea(

        child: LayoutBuilder(

          builder: (context, constraints) {

            return SingleChildScrollView(

              padding: EdgeInsets.symmetric(

                horizontal: horizontalPadding,

                vertical: 20,

              ),

              child: ConstrainedBox(

                constraints: BoxConstraints(

                  minHeight: constraints.maxHeight,

                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Home",

                      style: TextStyle(

                        fontSize:
                        isMobile ? 26 : 32,

                        fontWeight:
                        FontWeight.bold,

                        color: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.color,

                      ),

                    ),

                    SizedBox(
                      height: weatherSpacing,
                    ),

                    Text(

                      "Welcome $userName 👋",

                      style: TextStyle(

                        fontSize:
                        isMobile ? 22 : 28,

                        fontWeight:
                        FontWeight.bold,

                        color: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.color,

                      ),

                    ),

                    const SizedBox(height: 6),

                    Text(

                      "Manage your smart home easily",

                      style: TextStyle(

                        fontSize:
                        isMobile ? 14 : 16,

                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color,

                      ),

                    ),

                    SizedBox(
                      height: weatherSpacing,
                    ),

                    Text(

                      "Today's Weather",

                      style: TextStyle(

                        fontSize:
                        isMobile ? 18 : 22,

                        fontWeight:
                        FontWeight.bold,

                        color: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.color,

                      ),

                    ),

                    const SizedBox(height: 12),

                    weather == null

                        ? Text(

                      "Loading Weather...",

                      style: TextStyle(

                        color: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.color,

                      ),

                    )

                        : WeatherCard(

                      weather: weather!,

                    ),

                    SizedBox(
                      height: weatherSpacing,
                    ),

                    GridView.builder(

                      shrinkWrap: true,

                      physics:
                      const NeverScrollableScrollPhysics(),

                      itemCount: 3,

                      gridDelegate:

                      SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount: gridCount,

                        crossAxisSpacing: 12,

                        mainAxisSpacing: 12,

                        childAspectRatio:
                        isMobile ? 1.35 : 1.5,

                      ),

                      itemBuilder: (context, index) {

                        switch (index) {

                          case 0:

                            return _statusCard(

                              title: "Power",

                              value:
                              "${totalPower.toStringAsFixed(1)} W",

                              icon: Icons.bolt,

                              color: Colors.orange,

                            );

                          case 1:

                            return _statusCard(

                              title: "Devices",

                              value: "$devicesCount",

                              icon: Icons.devices,

                              color: Colors.blue,

                            );

                          default:

                            return _statusCard(

                              title: "Rooms",

                              value: "$roomsCount",

                              icon: Icons.home,

                              color: Colors.green,

                            );

                        }

                      },

                    ),

                    SizedBox(
                      height: weatherSpacing,
                    ),

                    Text(

                      "Quick Actions",

                      style: TextStyle(

                        fontSize:
                        isMobile ? 18 : 22,

                        fontWeight:
                        FontWeight.bold,

                        color: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.color,

                      ),

                    ),

                    const SizedBox(height: 15),

                    SizedBox(

                      width: double.infinity,

                      child: GestureDetector(

                        onTap: () async {

                          await turnAllOff();

                        },

                        child: Container(

                          constraints:

                          const BoxConstraints(

                            minHeight: 90,

                          ),

                          decoration:

                          BoxDecoration(

                            color: Colors.red
                                .withOpacity(.3),

                            borderRadius:
                            BorderRadius.circular(20),

                          ),

                          child: Column(

                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [

                              Icon(

                                Icons.power_off,

                                color: Theme.of(context)
                                    .brightness ==
                                    Brightness.dark

                                    ? Colors.red
                                    .withOpacity(.25)

                                    : Colors.red.shade100,

                              ),

                              const SizedBox(height: 10),

                              Text(

                                "All Off",

                                style: TextStyle(

                                  fontSize:
                                  isMobile ? 18 : 22,

                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.color,

                                ),

                              ),

                            ],

                          ),

                        ),

                      ),

                    ),

                    const SizedBox(height: 30),

                  ],

                ),

              ),

            );

          },

        ),

      ),

    );

  }
  Widget _statusCard({

    required String title,

    required String value,

    required IconData icon,

    required Color color,

  }) {

    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 600;

    return Container(

      padding: EdgeInsets.all(
        isMobile ? 14 : 18,
      ),

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(18),

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Container(

            padding: EdgeInsets.all(
              isMobile ? 8 : 10,
            ),

            decoration: BoxDecoration(

              color: color.withOpacity(.2),

              borderRadius: BorderRadius.circular(10),

            ),

            child: Icon(

              icon,

              color: color,

              size: isMobile ? 18 : 22,

            ),

          ),

          SizedBox(
            height: isMobile ? 12 : 16,
          ),

          FittedBox(

            fit: BoxFit.scaleDown,

            alignment: Alignment.centerLeft,

            child: Text(

              value,

              maxLines: 1,

              style: TextStyle(

                fontSize:
                isMobile ? 18 : 24,

                fontWeight:
                FontWeight.bold,

                color: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.color,

              ),

            ),

          ),

          const SizedBox(height: 4),

          FittedBox(

            fit: BoxFit.scaleDown,

            alignment: Alignment.centerLeft,

            child: Text(

              title,

              maxLines: 1,

              style: TextStyle(

                fontSize:
                isMobile ? 13 : 15,

                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color,

              ),

            ),

          ),

        ],

      ),

    );

  }

  Widget _actionButton(

      String title,

      IconData icon,

      Color color,

      ) {

    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 600;

    return Container(

      padding: EdgeInsets.symmetric(

        vertical: isMobile ? 14 : 18,

        horizontal: 12,

      ),

      decoration: BoxDecoration(

        color: color.withOpacity(.2),

        borderRadius: BorderRadius.circular(15),

      ),

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(

            icon,

            color: color,

            size: isMobile ? 24 : 30,

          ),

          SizedBox(
            height: isMobile ? 8 : 10,
          ),

          Flexible(

            child: FittedBox(

              fit: BoxFit.scaleDown,

              child: Text(

                title,

                textAlign: TextAlign.center,

                style: TextStyle(

                  fontSize:
                  isMobile ? 14 : 16,

                  color: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.color,

                ),

              ),

            ),

          ),

        ],

      ),

    );

  }

}