import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

  Uint8List? profileImage;

  final Color primaryColor =
  const Color(0xFFF59E0B);

  final Color cardColor =
  const Color(0xFF1E1E1E);

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

    FormData formData =
    FormData.fromMap({

      "image":
      MultipartFile.fromBytes(

        imageBytes,

        filename: fileName,

      ),

    });

    try {
      print("START UPLOAD");
      Response response =
      await Dio().put(

        "http://64.225.101.222:5000/api/auth/image",

        data: formData,

        options: Options(

          headers: {

            "Authorization":
            "bearer $token",

            "Content-Type":
            "multipart/form-data",

          },

        ),

      );

      print(response.data);

    } catch (e) {

      print(e);

    }

  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F0F0F),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
            const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(

                  "Profile",

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 24,

                    fontWeight:
                    FontWeight.bold,

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

                            color: cardColor,

                            borderRadius:
                            BorderRadius.circular(
                              24,
                            ),

                          ),

                          child: Center(

                            child: CircleAvatar(

                              radius: 42,

                              backgroundColor:
                              Colors.white,

                              backgroundImage:

                              profileImage != null

                                  ? MemoryImage(profileImage!)

                                  : null,

                              child:

                              profileImage == null

                                  ? const Icon(

                                Icons.person,

                                size: 60,

                                color:
                                Colors.grey,

                              )

                                  : null,

                            ),

                          ),

                        ),

                      ),

                      const SizedBox(height: 20),

                      Text(

                        name,

                        style: const TextStyle(

                          color: Colors.white,

                          fontSize: 22,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),

                      const SizedBox(height: 5),

                      Text(

                        email,

                        style: const TextStyle(

                          color:
                          Colors.white70,

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

                ),

                const SizedBox(height: 15),

                _buildTile(

                  Icons.history,

                  "Usage History",

                ),

                const SizedBox(height: 30),

                ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    primaryColor,

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
                    await SharedPreferences
                        .getInstance();

                    await prefs.clear();

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

        color:
        const Color(0xFF14203B),

        borderRadius:
        BorderRadius.circular(18),

      ),

      child: Column(

        children: [

          Text(

            value,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 18,

              fontWeight:
              FontWeight.bold,

            ),

          ),

          const SizedBox(height: 8),

          Text(

            title,

            style: const TextStyle(

              color: Colors.white70,

            ),

          ),

        ],

      ),

    );

  }

  Widget _buildTile(
      IconData icon,
      String title,
      ) {

    return Container(

      decoration: BoxDecoration(

        color: cardColor,

        borderRadius:
        BorderRadius.circular(18),

      ),

      child: ListTile(

        leading: Icon(
          icon,
          color: Colors.white,
        ),

        title: Text(

          title,

          style: const TextStyle(
            color: Colors.white,
          ),

        ),

        trailing: const Icon(

          Icons.arrow_forward_ios,

          color: Colors.white38,

          size: 16,

        ),

      ),

    );

  }

}