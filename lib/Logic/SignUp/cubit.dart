import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled55/Logic/SignUp/states.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  Future signUp(String userName, String userEmail, String userPass) async {
    emit(SignUpLoadingState());

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPass,
      );

      User? user = userCredential.user;

      if (user != null) {
        String uid = user.ud;

        await http.post(
          Uri.parse("http://64.225.101.222:5000/api/auth/register"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": userName,
            "email": userEmail,
            "password": userPass,
          }),
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLogged", true);
        await prefs.setString("name", userName);
        await prefs.setString("email", userEmail);
        await prefs.setString("uid", uid);

        emit(SignUpSuccessState());
      }
    } catch (e) {
      emit(SignUpErrorState(em: e.toString()));
    }
  }
}