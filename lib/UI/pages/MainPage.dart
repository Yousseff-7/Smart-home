import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RoomsPage.dart';
import 'Profile_Page.dart';
import 'automation_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  State<MainPage> createState() =>
      _MainPageState();

}

class _MainPageState
    extends State<MainPage> {

  int currentIndex = 0;

  int roomsCount = 0;
  int devicesCount = 0;

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadCounts();

  }

  Future loadCounts() async {

    final prefs =
    await SharedPreferences.getInstance();

    String token =
        prefs.getString("token") ?? "";

    try {

      /// ===== GET ROOMS =====

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

      int totalDevices = 0;

      /// ===== GET DEVICES =====

      for (var room in rooms) {

        Response devicesResponse =
        await Dio().get(

          "http://64.225.101.222:5000/api/devices/${room["_id"]}",

          options: Options(

            headers: {

              "Authorization":
              "bearer $token",

            },

          ),

        );

        List devices =
            devicesResponse.data;

        totalDevices +=
            devices.length;

      }

      setState(() {

        roomsCount =
            rooms.length;

        devicesCount =
            totalDevices;

        isLoading = false;

      });

    } catch (e) {

      print(e);

      setState(() {

        isLoading = false;

      });

    }

  }

  @override
  Widget build(BuildContext context) {

    final pages = [

      const HomePage(),

      const RoomsPage(),

      const AutomationPage(),
      ProfilePage(

        roomsNumber:
        roomsCount,

        devicesNumber:
        devicesCount,

      ),

    ];

    return Scaffold(

        backgroundColor:
        Theme.of(context).scaffoldBackgroundColor,

      body: isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : IndexedStack(

        index: currentIndex,

        children: pages,

      ),

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex:
        currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex =
                index;

          });

        },

        backgroundColor:
        Theme.of(context).cardColor,
        selectedItemColor:
        Colors.orange,

        unselectedItemColor:
        Colors.grey,

        type:
        BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(

            icon: Icon(Icons.home),

            label: "Home",

          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.grid_view),

            label: "Rooms",

          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.flash_on),

            label: "Automation",

          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.person),

            label: "User",

          ),

        ],

      ),

    );

  }

}