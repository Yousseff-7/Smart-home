import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;


  final Color primaryColor = const Color(0xFFF59E0B);

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
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// ===== ACCOUNT =====
          const Text(
            "Account",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          _card([
            _tile(Icons.person, "Edit Profile"),
            _divider(),
            _tile(Icons.lock, "Change Password"),
          ]),

          const SizedBox(height: 25),

          /// ===== PREFERENCES =====
          const Text(
            "Preferences",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          _card([
            _switchTile("Notifications", notifications, (val) {
              setState(() => notifications = val);
            }),
            _divider(),
            Consumer<ThemeProvider>(
              builder: (
                  context,
                  themeProvider,
                  child,
                  ) {

                return SwitchListTile(

                  value:
                  themeProvider.isDark,

                  onChanged: (val) {

                    themeProvider
                        .toggleTheme();

                  },

                  activeColor:
                  Colors.black,

                  activeTrackColor:
                  primaryColor,

                  title: const Text(
                    "Dark Mode",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  secondary: Icon(

                    themeProvider.isDark
                        ? Icons.dark_mode
                        : Icons.light_mode,

                    color: Colors.white,

                  ),
                );
              },
            ),
          ]),

          const SizedBox(height: 25),

          /// ===== ABOUT =====
          const Text(
            "About",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          _card([
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white70),
              title: const Text(
                "App Version",
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Text(
                "1.0.0",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ]),

          const SizedBox(height: 40),

          /// ===== LOGOUT =====
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              minimumSize: const Size(double.infinity, 55),
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  /// ===== CARD =====
  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  /// ===== TILE =====
  Widget _tile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
      onTap: () {},
    );
  }

  /// ===== SWITCH TILE =====
  Widget _switchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.black,
      activeTrackColor: primaryColor,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  /// ===== DIVIDER =====
  Widget _divider() {
    return const Divider(color: Colors.white10, height: 1);
  }
}