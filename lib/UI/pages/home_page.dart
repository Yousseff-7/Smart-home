import 'package:flutter/material.dart';
import '../../models/device_model.dart';
import '../../models/room_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/weather_model.dart';
import '../../services/device_service.dart';
import '../../services/room_service.dart';
import '../../services/weather_service.dart';
import '../widets/weather_card.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();

}

class _HomePageState
    extends State<HomePage> {

  final RoomService roomService =
  RoomService();

  final DeviceService deviceService =
  DeviceService();
  final WeatherService weatherService =
  WeatherService();

  WeatherModel? weather;

  bool isLoading = true;

  int roomsCount = 0;
  int devicesCount = 0;

  double totalPower = 0;
  List<DeviceModel> allDevices = [];

  @override
  void initState() {
    super.initState();
    loadData();
    loadWeather();


  }

  Future loadData() async {

    try {

      List<RoomModel> rooms =
      await roomService.getRooms();

      roomsCount = rooms.length;

      allDevices.clear();

      for(var room in rooms){

        List<DeviceModel> devices =
        await deviceService.getDevices(
          room.id!,
        );

        allDevices.addAll(devices);

      }

      devicesCount =
          allDevices.length;

      totalPower =
          allDevices
              .where(
                (e)=>e.state=="on",
          )
              .length * 10;
      weather =
      await weatherService.getWeather();
    } catch(e){

      print(e);

    }

    setState(() {

      isLoading = false;

    });

  }
  Future<void> loadWeather() async {

    try {

      WeatherModel result =
      await weatherService.getWeather();

      print("CITY = ${result.city}");
      print("TEMP = ${result.temperature}");

      setState(() {
        weather = result;
      });

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

          backgroundColor:
          Theme.of(context).cardColor,

          elevation: 10,

          margin: const EdgeInsets.all(20),

          shape: RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(16),

          ),

          content: Row(

            children: [

              const Icon(

                Icons.power_off,

                color: Colors.red,

              ),

              const SizedBox(width: 12),

              const Expanded(

                child: Text(

                  "All devices turned off successfully",

                  style: TextStyle(

                    color: Colors.white,

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

    return Scaffold(

      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,

      body:

      isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(

                "Home",

                style: TextStyle(

                  fontSize: 26,

                  fontWeight:
                  FontWeight.bold,

                  color:
                  Theme.of(context).textTheme.titleLarge?.color,

                ),

              ),

              const SizedBox(
                  height: 25
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                   Text(
                    "Welcome Marwa 👋",
                    style: TextStyle(
                      color:Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Manage your smart home easily",
                    style: TextStyle(
                      color:Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Today's Weather",
                style: TextStyle(
                  color:Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),
              weather == null
                  ? Text(
                "Loading Weather...",
                style: TextStyle(
                  color:Theme.of(context).textTheme.titleLarge?.color,
                ),
              )
                  : WeatherCard(
                weather: weather!,
              ),

              const SizedBox(height: 25),
              const SizedBox(height: 25),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                crossAxisCount: 2,

                crossAxisSpacing: 12,
                mainAxisSpacing: 12,

                childAspectRatio: 1.4,

                children: [

                  _statusCard(
                    title: "Power",
                    value: "${totalPower.toStringAsFixed(1)} W",
                    icon: Icons.bolt,
                    color: Colors.orange,
                  ),

                  _statusCard(
                    title: "Devices",
                    value: "$devicesCount",
                    icon: Icons.devices,
                    color: Colors.blue,
                  ),

                  _statusCard(
                    title: "Rooms",
                    value: "$roomsCount",
                    icon: Icons.home,
                    color: Colors.green,
                  ),
                  

                ],
              ),
              const SizedBox(
                  height:30
              ),

              Text(

                "Quick Actions",

                style: TextStyle(

                  color:
                  Theme.of(context).textTheme.titleLarge?.color,

                  fontSize:18,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

              const SizedBox(
                  height:15
              ),

              Row(
                children: [

                  Expanded(
                    child: GestureDetector(

                      onTap: () async {

                        await turnAllOff();

                      },

                      child: Container(

                        height: 90,

                        decoration: BoxDecoration(

                          color: Colors.red.withOpacity(0.3),

                          borderRadius: BorderRadius.circular(20),

                        ),

                        child: Column(

                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [

                            const Icon(
                              Icons.power_off,
                              color: Colors.red,
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "All Off",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.titleLarge?.color,
                                fontSize: 18,
                              ),
                            ),

                          ],

                        ),

                      ),

                    ),
                  ),

                ],
              )



            ],

          ),

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

    return Container(

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color:
        const Color(0xFF1E1E1E),

        borderRadius:
        BorderRadius.circular(18),

      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children:[

          Container(

            padding:
            const EdgeInsets.all(8),

            decoration:
            BoxDecoration(

              color:
              color.withOpacity(0.2),

              borderRadius:
              BorderRadius.circular(10),

            ),

            child:

            Icon(

              icon,

              color:color,

              size:18,

            ),

          ),

          const SizedBox(
              height:12
          ),

          Text(

            value,

            style:
            TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.bold,

              color:
              Theme.of(context).textTheme.titleLarge?.color,

            ),

          ),

          const SizedBox(
              height:4
          ),

          Text(

            title,

            style:
            TextStyle(

              color:
              Theme.of(context).textTheme.titleLarge?.color,

              fontSize:12,

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

      ){

    return Container(

      padding:

      const EdgeInsets.symmetric(

        vertical:14,

      ),

      decoration:

      BoxDecoration(

        color:

        color.withOpacity(0.2),

        borderRadius:

        BorderRadius.circular(15),

      ),

      child: Column(

        children:[

          Icon(

            icon,

            color:color,

          ),

          const SizedBox(
              height:6
          ),

          Text(

            title,

            style:
            TextStyle(

              color:
              Theme.of(context).textTheme.titleLarge?.color,

            ),

          ),

        ],

      ),

    );

  }

}