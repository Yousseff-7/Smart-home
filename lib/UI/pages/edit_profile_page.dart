import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentEmail,
  });

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String imageUrl = "";
  Uint8List? profileImage;
  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(
          text: widget.currentName,
        );

    emailController =
        TextEditingController(
          text: widget.currentEmail,
        );

    passwordController =
        TextEditingController();

  }
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Future updateProfile() async {

    final prefs =
    await SharedPreferences.getInstance();

    String token =
        prefs.getString("token") ?? "";

    if (imageUrl.isEmpty) {
      imageUrl = prefs.getString("image") ?? "";
    }
    try {
      print("IMAGE URL = $imageUrl");
      print("UPDATE PROFILE START");
      Response response =
      await Dio().put(

        "http://64.225.101.222:5000/api/auth/me",

        data: {
          "name": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "image": imageUrl,
        },

        options: Options(
          headers: {

            "Authorization":
            "bearer $token",

          },
        ),
      );
      print(response.data);
      await prefs.setString(
        "name",
        response.data["user"]["name"],
      );

      await prefs.setString(
        "email",
        response.data["user"]["email"],
      );
      await prefs.setString(
        "image",
        response.data["user"]["image"] ?? "",
      );

      if (mounted) {
        Navigator.pop(context, true);
      }

    } catch (e) {

      if (e is DioException) {

        print("STATUS = ${e.response?.statusCode}");
        print("DATA = ${e.response?.data}");
        print("URL = ${e.requestOptions.path}");

      }

      print(e);
    }
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

    if (!mounted) return;

    setState(() {
      profileImage = imageBytes;
    });

    FormData formData =
    FormData.fromMap({

      "file":
      MultipartFile.fromBytes(
        imageBytes,
        filename: pickedFile.name,
      ),

      "upload_preset":
      "flutter_profile",
    });

    try {

      Response response =
      await Dio().post(

        "https://api.cloudinary.com/v1_1/deds7dd60/image/upload",

        data: formData,
      );
      imageUrl = response.data["secure_url"];

      final prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        "image",
        imageUrl,
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {

      print(e);

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [

            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickAndUploadImage,

              child: CircleAvatar(
                radius: 55,
                backgroundColor: Theme.of(context).colorScheme.primary,

                backgroundImage:
                profileImage != null
                    ? MemoryImage(profileImage!)
                    : imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,

                child:
                profileImage == null
                    ? Icon(
                  Icons.camera_alt,
                  size: 35,
                  color: Theme.of(context).colorScheme.onPrimary,
                )
                    : null,
              ),
            ),
            const SizedBox(height: 30),

            Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Theme.of(context).cardColor,

                borderRadius:
                BorderRadius.circular(20),

              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    "Personal Information",
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),

                  TextField(

                    controller: nameController,

                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.color,
                    ),

                    decoration: InputDecoration(

                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).iconTheme.color,
                      ),

                      labelText: "Name",

                      filled: true,

                      fillColor: Theme.of(context)
                          .inputDecorationTheme
                          .fillColor,
                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            15),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(

                    controller: emailController,

                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.color,
                    ),

                    decoration: InputDecoration(

                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).iconTheme.color,
                      ),

                      labelText: "Email",

                      filled: true,
                      fillColor: Theme.of(context)
                          .inputDecorationTheme
                          .fillColor,
                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            15),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(

                    controller:
                    passwordController,

                    obscureText: true,

                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.color,
                    ),
                    decoration: InputDecoration(

                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      labelText:
                      "New Password",

                      filled: true,

                      fillColor: Theme.of(context)
                          .inputDecorationTheme
                          .fillColor,
                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            15),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed: () async {
                  await updateProfile();
                },
                child: const Text("Save Changes"),
              )
            ),
          ],
        ),
      ),

    );
  }
}