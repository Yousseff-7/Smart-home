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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2235),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    AssetImage("assets/images/profile.jpg"),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// Stats
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

            /// Edit Profile
            Card(
              color: const Color(0xFF1A2235),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
                onTap: () {},
              ),
            ),

            const SizedBox(height: 12),

            /// Usage History
            Card(
              color: const Color(0xFF1A2235),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.white),
                title: const Text(
                  "Usage History",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
                onTap: () {},
              ),
            ),

            const Spacer(),

            /// Logout Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.logout),
              label: const Text(
                "Logout",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        "CONFIRM",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                          'Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A2235),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: ()async {
                            Navigator.pop(context); // close dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool("isLogged", false);
                          },
                          child: const Text("Yes"),
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
    );
  }
}