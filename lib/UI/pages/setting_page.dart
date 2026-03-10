import 'package:flutter/material.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: darkMode ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar( 
        leading: Icon(Icons.arrow_back,color:darkMode ? Colors.white : const Color(0xFF0F172A),),
        elevation: 0,
        backgroundColor: darkMode ? const Color(0xFF0F172A) : Colors.white,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: darkMode ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        children: [
          /// ACCOUNT
          Text(
            "Account",
            style: TextStyle(
              color: darkMode ? Colors.white : const Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          _buildCard(
            children: [
              _buildTile(Icons.person, "Edit Profile", onTap: () {}),
              const Divider(height: 1, color: Colors.white10),
              _buildTile(Icons.lock, "Change Password", onTap: () {}),
            ],
          ),

          const SizedBox(height: 30),

          /// PREFERENCES
          Text(
            "Preferences",
            style: TextStyle(
              color: darkMode ? Colors.white : const Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          _buildCard(
            children: [
              SwitchListTile(
                activeColor: primaryColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: const Text(
                  "Notifications",
                  style: TextStyle(color: Colors.white),
                ),
                value: notifications,
                onChanged: (val) {
                  setState(() => notifications = val);
                },
              ),
              const Divider(height: 1, color: Colors.white10),
              SwitchListTile(
                activeColor: primaryColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: const Text(
                  "Dark Mode",
                  style: TextStyle(color: Colors.white),
                ),
                value: darkMode,
                onChanged: (val) {
                  setState(() => darkMode = val);
                },
              ),
            ],
          ),

          const SizedBox(height: 30),

          Text(
            "About",
            style: TextStyle(
              color: darkMode ? Colors.white : const Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          _buildCard(
            children: const [
              ListTile(
                leading: Icon(Icons.info_outline, color: Colors.white),
                title: Text(
                  "App Version",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  "1.0.0",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          /// LOGOUT BUTTON
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(double.infinity, 55),
            ),
            icon: const Icon(Icons.logout),
            label: const Text(
              "Logout",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white38,
      ),
      onTap: onTap,
    );
  }
}
