import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled55/UI/pages/RoomsPage.dart';
import 'package:untitled55/UI/widets/AuthButtons.dart';
import 'package:untitled55/UI/widets/NormalTextForms.dart';
import 'package:untitled55/UI/widets/PassTextFroms.dart';
import '../../Logic/SignUp/cubit.dart';
import '../../Logic/SignUp/states.dart';
import 'login_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state) {
          if (state is SignUpSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RoomsPage()),
            );
          }else if (state is SignUpErrorState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Error"),
                content: Text(state.em),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(width * 0.05),
                          child: Image.asset(
                            "assets/images/energy.jpg",
                            height: height * 0.25,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: height * 0.05),

                        NormalTextForms(
                          controller: firstNameController,
                          hintText: 'First Name',
                          validatorText: 'Enter first name',
                          width: width,
                        ),
                        SizedBox(height: height * 0.02),

                        NormalTextForms(
                          controller: lastNameController,
                          hintText: 'Last Name',
                          validatorText: 'Enter last name',
                          width: width,
                        ),
                        SizedBox(height: height * 0.02),

                        NormalTextForms(
                          icon: Icon(Icons.email),
                          controller: emailController,
                          hintText: 'Email',
                          validatorText: 'Enter your email',
                          width: width,
                        ),
                        SizedBox(height: height * 0.02),
                        PassTextForms(
                          onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                          controller: passwordController,
                          visible: isPasswordHidden,
                          width: width,
                          hintText: 'Password',
                          validator: (v) => v == null || v.length < 4
                              ? "Password too short"
                              : null,
                        ),
                        SizedBox(height: height * 0.02),
                        PassTextForms(
                          onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                          controller: confirmController,
                          visible: isPasswordHidden,
                          width: width,
                          hintText: 'Confirm your password',
                          validator: (v) => v != passwordController.text
                              ? "Passwords not match"
                              : null,
                        ),
                        SizedBox(height: height * 0.05),

                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignUpCubit>().signUp(
                                firstNameController.text,
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                          child: Authbutton(
                            text: 'Register',
                            height: height,
                            width: width,
                          ),
                        ),
                        SizedBox(height: height * 0.02),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text("Login"),
                            ),
                          ],
                        ),
                      ],
                    ),
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
