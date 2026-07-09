
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'edit_profile_page.dart';
import 'usage_history_page.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {

  final int roomsNumber;
  final int devicesNumber;

  const ProfilePage({

    super.key,

    required this.roomsNumber,
    required this.devicesNumber,

  });

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {

  String name = "";
  String email = "";
  String image = "";



  @override
  void initState() {
    super.initState();

    loadProfileData();
  }

  Future loadProfileData() async {
    final prefs =
    await SharedPreferences.getInstance();
    setState(() {
      name =
          prefs.getString("name") ?? "";

      email =
          prefs.getString("email") ?? "";
      image =
          prefs.getString("image") ?? "";
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final size = MediaQuery
        .of(context)
        .size;

    final width = size.width;

    final isMobile = width < 600;

    final isTablet = width >= 600 && width < 1024;

    final horizontalPadding =
    isMobile ? 16.0 : isTablet ? 24.0 : 40.0;

    final avatarSize =
    isMobile ? 120.0 : isTablet ? 140.0 : 160.0;

    final avatarRadius =
    isMobile ? 40.0 : isTablet ? 48.0 : 56.0;

    return Scaffold(

      backgroundColor:
      theme.scaffoldBackgroundColor,

      body: SafeArea(

        child: LayoutBuilder(

          builder: (context, constraints) {
            return SingleChildScrollView(

              padding: EdgeInsets.all(horizontalPadding),

              child: ConstrainedBox(

                constraints: BoxConstraints(

                  minHeight: constraints.maxHeight,

                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Profile",

                      style: TextStyle(

                        color: theme.textTheme.titleLarge?.color,

                        fontSize: isMobile ? 22 : 26,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    SizedBox(
                      height: isMobile ? 24 : 30,
                    ),

                    Center(

                      child: Column(

                        children: [

                          GestureDetector(

                            onTap: () async {

                              final result = await Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (_) => EditProfilePage(

                                    currentName: name,

                                    currentEmail: email,

                                  ),

                                ),

                              );

                              if (result == true) {

                                await loadProfileData();

                              }

                            },

                            child: Container(

                              width: avatarSize,

                              height: avatarSize,

                              decoration: BoxDecoration(

                                color: theme.cardColor,

                                borderRadius: BorderRadius.circular(24),

                              ),

                              child: Center(

                                child: CircleAvatar(

                                  radius: avatarRadius,

                                  backgroundColor: theme.colorScheme.primary,

                                  backgroundImage: image.isNotEmpty

                                      ? NetworkImage(image)

                                      : null,

                                  child: image.isEmpty

                                      ? Icon(

                                    Icons.person,

                                    color: theme.colorScheme.onPrimary,

                                    size: avatarRadius,

                                  )

                                      : null,

                                ),

                              ),

                            ),

                          ),

                          SizedBox(
                            height: isMobile ? 16 : 20,
                          ),

                          FittedBox(

                            child: Text(

                              name,

                              style: TextStyle(

                                color: theme.textTheme.titleLarge?.color,

                                fontSize: isMobile ? 20 : 22,

                                fontWeight: FontWeight.bold,

                              ),

                            ),

                          ),

                          const SizedBox(height: 5),

                          FittedBox(

                            child: Text(

                              email,

                              style: TextStyle(

                                color: theme.textTheme.bodyMedium?.color,

                                fontSize: isMobile ? 13 : 14,

                              ),

                            ),

                          ),

                        ],

                      ),

                    ),

                    SizedBox(
                      height: isMobile ? 24 : 30,
                    ),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isSmall = constraints.maxWidth < 650;

                        final double cardWidth = isSmall
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 30) / 3;

                        return Wrap(

                          spacing: 15,

                          runSpacing: 15,

                          children: [

                            SizedBox(

                              width: cardWidth,

                              child: _buildStatCard(

                                widget.roomsNumber.toString(),

                                "Rooms",

                              ),

                            ),

                            SizedBox(

                              width: cardWidth,

                              child: _buildStatCard(

                                widget.devicesNumber.toString(),

                                "Devices",

                              ),

                            ),

                            SizedBox(

                              width: cardWidth,

                              child: _buildStatCard(

                                "2.4 kWh",

                                "Today",

                              ),

                            ),

                          ],

                        );
                      },

                    ),

                    SizedBox(
                      height: isMobile ? 24 : 28,
                    ),

                    _buildTile(

                      Icons.edit,

                      "Edit Profile",

                      onTap: () async {
                        final result = await Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                EditProfilePage(

                                  currentName: name,

                                  currentEmail: email,

                                ),

                          ),

                        );

                        if (result == true) {
                          loadProfileData();
                        }
                      },

                    ),

                    const SizedBox(height: 15),

                    _buildTile(

                      Icons.history,

                      "Usage History",

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) => const UsageHistoryPage(),

                          ),

                        );

                      },

                    ),

                    SizedBox(
                      height: isMobile ? 24 : 30,
                    ),

                    Container(

                      margin: const EdgeInsets.only(top: 15),

                      decoration: BoxDecoration(

                        color: theme.cardColor,

                        borderRadius: BorderRadius.circular(18),

                      ),

                      child: Consumer<ThemeProvider>(

                        builder: (context,

                            themeProvider,

                            child,) {
                          return SwitchListTile(

                            title: Text(

                              "Dark Mode",

                              style: TextStyle(

                                color: theme.textTheme.titleLarge?.color,

                              ),

                            ),

                            secondary: Icon(

                              themeProvider.isDark

                                  ? Icons.dark_mode

                                  : Icons.light_mode,

                              color: theme.textTheme.titleLarge?.color,

                            ),

                            value: themeProvider.isDark,

                            onChanged: (value) {
                              themeProvider.toggleTheme();
                            },

                          );
                        },

                      ),

                    ),

                    SizedBox(
                      height: isMobile ? 24 : 30,
                    ),

                    SizedBox(

                      width: double.infinity,

                      height: 56,

                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(

                          backgroundColor: theme.primaryColor,

                          shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(18),

                          ),

                        ),

                        onPressed: () async {
                          final prefs =
                          await SharedPreferences.getInstance();

                          await prefs.clear();

                          Navigator.pushAndRemoveUntil(

                            context,

                            MaterialPageRoute(

                              builder: (_) => const LoginScreen(),

                            ),

                                (route) => false,

                          );
                        },

                        child: FittedBox(

                          child: const Row(

                            mainAxisSize: MainAxisSize.min,

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [

                              Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),

                              SizedBox(width: 10),

                              Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
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
          },

        ),

      ),

    );
  }

  Widget _buildStatCard(String value,
      String title,) {
    final width = MediaQuery
        .of(context)
        .size
        .width;

    final bool isMobile = width < 600;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
      ),

      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 18 : 22,
        horizontal: 12,
      ),

      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .cardColor,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: Theme
                    .of(context)
                    .textTheme
                    .titleLarge
                    ?.color,
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: isMobile ? 6 : 8,
          ),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.color,
                fontSize: isMobile ? 13 : 15,
              ),
            ),
          ),

        ],
      ),


    );
  }

  Widget _buildTile(IconData icon,
      String title, {
        VoidCallback? onTap,
      }) {
    final width = MediaQuery
        .of(context)
        .size
        .width;

    final bool isMobile = width < 600;

    return Container(

      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .cardColor,
        borderRadius: BorderRadius.circular(18),
      ),

      child: ListTile(

        onTap: onTap,

        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: isMobile ? 2 : 6,
        ),

        leading: Icon(
          icon,
          color: Theme
              .of(context)
              .textTheme
              .titleLarge
              ?.color,
          size: isMobile ? 22 : 26,
        ),

        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: TextStyle(
              color: Theme
                  .of(context)
                  .textTheme
                  .titleLarge
                  ?.color,
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme
              .of(context)
              .textTheme
              .titleLarge
              ?.color,
          size: isMobile ? 14 : 16,
        ),

      ),
    );
  }
}