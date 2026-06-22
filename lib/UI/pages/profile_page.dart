import 'dart:typed_data';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import 'edit_profile_page.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

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

class _ProfilePageState
    extends State<ProfilePage> {

  String name = "";
  String email = "";
  String image = "";

  Uint8List? profileImage;


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

  Future pickAndUploadImage() async {

    final picker = ImagePicker();

    final pickedFile =
    await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    Uint8List imageBytes =
    await pickedFile.readAsBytes();

    setState(() {

      profileImage = imageBytes;

    });

    final prefs =
    await SharedPreferences.getInstance();

    String token =
        prefs.getString("token") ?? "";

    String fileName =
        pickedFile.name;

    FormData formData = FormData();

    formData.files.add(
      MapEntry(
        "file",
        MultipartFile.fromBytes(
          imageBytes,
          filename: "profile.jpg",
        ),
      ),
    );

    formData.fields.add(
      const MapEntry(
        "upload_preset",
        "flutter_profile",
      ),
    );
    try {

      print("START UPLOAD");

      Response response = await Dio().post(
        "https://api.cloudinary.com/v1_1/deds7dd60/image/upload",
        data: formData,
      );

      print(response.data);

    } on DioException catch (e) {

      print("STATUS = ${e.response?.statusCode}");
      print("DATA = ${e.response?.data}");
      print("URL = ${e.requestOptions.uri}");

    }

  }




  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(

      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
            const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  "Profile",
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

                Center(

                  child: Column(

                    children: [

                      GestureDetector(

                        onTap:
                        pickAndUploadImage,

                        child: Container(

                          width: 130,
                          height: 130,

                          decoration:
                          BoxDecoration(

                            color: Theme.of(context).cardColor,

                            borderRadius:
                            BorderRadius.circular(
                              24,
                            ),

                          ),

                          child: Center(

                            child: CircleAvatar(

                              radius: 42,

                              backgroundColor: Colors.white,

                              backgroundImage:

                              image.isNotEmpty

                                  ? NetworkImage(image)

                                  : null,

                              child:

                              image.isEmpty

                                  ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )

                                  : null,
                            ),

                          ),

                        ),

                      ),

                      const SizedBox(height: 20),

                      Text(

                        name,

                        style: TextStyle(

                          color: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.color,

                          fontSize: 22,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),

                      const SizedBox(height: 5),

                      Text(

                        email,

                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontSize: 14,
                        ),

                      ),

                    ],

                  ),

                ),

                const SizedBox(height: 30),

                Row(

                  children: [

                    Expanded(

                      child: _buildStatCard(

                        widget.roomsNumber
                            .toString(),

                        "Rooms",

                      ),

                    ),

                    const SizedBox(width: 15),

                    Expanded(

                      child: _buildStatCard(

                        widget.devicesNumber
                            .toString(),

                        "Devices",

                      ),

                    ),

                    const SizedBox(width: 15),

                    Expanded(

                      child: _buildStatCard(

                        "2.4 kWh",

                        "Today",

                      ),

                    ),

                  ],

                ),

                const SizedBox(height: 28),

                _buildTile(
                  Icons.edit,
                  "Edit Profile",
                  onTap: () async {
                    final result =
                        await Navigator.push(

                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            EditProfilePage(
                              currentName: name,
                              currentEmail: email,
                            ),
                      ),
                    );

                    if(result == true){
                      loadProfileData();
                    }
                  },
                ),
                const SizedBox(height: 15),

                _buildTile(

                  Icons.history,

                  "Usage History",

                ),

                const SizedBox(height: 30),
                Container(

                  margin: const EdgeInsets.only(
                    top: 15,
                  ),

                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius:
                    BorderRadius.circular(18),
                  ),

                  child: Consumer<ThemeProvider>(

                    builder: (
                        context,
                        themeProvider,
                        child,
                        ) {

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

                        value:
                        themeProvider.isDark,

                        onChanged: (value) {

                          themeProvider
                              .toggleTheme();

                        },

                      );
                    },
                  ),
                ),

                ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor: theme.primaryColor,

                    minimumSize:
                    const Size(
                      double.infinity,
                      56,
                    ),

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),

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

                  child: const Row(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

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

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),

                    ],

                  ),

                ),

              ],

            ),

          ),

        ),

      ),





    );

  }

  Widget _buildStatCard(

      String value,
      String title,

      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        vertical: 22,
      ),

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,

        borderRadius:
        BorderRadius.circular(18),

      ),

      child: Column(

        children: [

          Text(

            value,

            style:  TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.color,),

          ),

          const SizedBox(height: 8),

          Text(

            title,

            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color,),

          ),

        ],

      ),

    );

  }

  Widget _buildTile(
      IconData icon,
      String title, {
        VoidCallback? onTap,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: Theme.of(context)
              .textTheme
              .titleLarge
              ?.color,
        ),
        title: Text(
          title,
          style:  TextStyle(
            color: Theme.of(context)
                .textTheme
                .titleLarge
                ?.color,
          ),
        ),
        trailing:  Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context)
              .textTheme
              .titleLarge
              ?.color,
          size: 16,
        ),
      ),
    );
  }

}