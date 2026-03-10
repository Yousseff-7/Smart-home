import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled55/Logic/LogIn/cubit.dart';
import 'package:untitled55/Logic/LogIn/states.dart';
import 'package:untitled55/UI/widets/AuthButtons.dart';
import 'RoomsPage.dart';
import 'register_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoomsPage()),
            );
          } else if (state is LoginErrorState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Error"),
                content: const Text("Invalid email or password"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F2027),
                    Color(0xFF203A43),
                    Color(0xFF2C5364),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.07,
                    vertical: height * 0.03,
                  ),
                  child: Column(
                    children: [
                      /// 🏠 IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(width * 0.05),
                        child: Image.asset(
                          "assets/images/the future house.jpg",
                          height: height * 0.25,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(height: height * 0.05),

                      /// 📧 EMAIL
                      TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white70,
                          ),
                          hintText: "Email",
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.04),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      /// 🔒 PASSWORD (Visible toggle added)
                      TextField(
                        controller: passwordController,
                        obscureText: isPasswordHidden,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white70,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                          ),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.04),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.05),

                      /// 🔵 LOGIN BUTTON
                      InkWell(
                        onTap: () {
                          context.read<LoginCubit>().login(
                            emailController.text,
                            passwordController.text,
                          );
                        },
                        child: Authbutton(
                          text: 'Login',
                          height: height,
                          width: width,
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      /// 📝 REGISTER
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
