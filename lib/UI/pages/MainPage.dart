import 'package:flutter/material.dart';
import 'RoomsPage.dart';
import 'Profile_Page.dart';
import 'Setting_Page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final pages = [
    const HomePage(),      // 👈 دي صفحتك الحالية (Home)
    const RoomsPage(),        // 👈 ممكن تعملي Rooms مختلفة بعدين
    const Center(child: Text("Automation")),
    const ProfilePage(roomsNumber: 0, devicesNumber: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      body: pages[currentIndex],

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(Icons.home, "Home", 0),
            _item(Icons.grid_view, "Rooms", 1),
            _item(Icons.flash_on, "Automation", 2),
            _item(Icons.person, "User", 3),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, int index) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.orange : Colors.white54),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.orange : Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}