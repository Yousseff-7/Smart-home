import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled55/UI/pages/login_page.dart';
import 'package:untitled55/UI/widets/StatCard.dart';

class ProfilePage extends StatefulWidget {
  final int roomsNumber;
  final int devicesNumber;

  const ProfilePage({
    super.key,
    required this.roomsNumber,
    required this.devicesNumber,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = "";
  String name = "";

  final Color primaryColor = const Color(0xFFF59E0B);

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  void loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String savedName = prefs.getString("name") ?? '';
    String savedEmail = prefs.getString("email") ?? '';

    setState(() {
      name = savedName;
      email = savedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// PROFILE CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage:
                    AssetImage("assets/images/profile.jpg"),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// STATS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatCard(
                  title: 'Rooms',
                  value: widget.roomsNumber.toString(),
                ),
                StatCard(
                  title: 'Devices',
                  value: widget.devicesNumber.toString(),
                ),
                const StatCard(
                  title: 'Today',
                  value: '2.4 kWh',
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// EDIT PROFILE
            _menuCard(Icons.edit, "Edit Profile"),

            const SizedBox(height: 12),

            /// USAGE HISTORY
            _menuCard(Icons.history, "Usage History"),

            const Spacer(),

            /// LOGOUT BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.black),
              label: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ================= MENU CARD =================
  Widget _menuCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.white38,
        ),
        onTap: () {},
      ),
    );
  }

  /// ================= LOGOUT DIALOG =================
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Logout",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(color: Colors.black87),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.orange),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
              ),
              onPressed: () async {
                Navigator.pop(context);

                final prefs = await SharedPreferences.getInstance();
                prefs.setBool("isLogged", false);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}