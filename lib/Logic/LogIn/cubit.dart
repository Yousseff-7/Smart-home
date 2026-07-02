import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled55/Logic/LogIn/states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  final dio = Dio();

  Future login(String userEmail, String userPass) async {
    emit(LoginLoadingState());

    try {
      final data = {
        "email": userEmail,
        "password": userPass,
      };


      Response response = await dio.post(
        'http://64.225.101.222:5000/api/auth/login',
        data: data,
      );

      String token = response.data["token"];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool("isLogged", true);
      await prefs.setString("token", token);
      await prefs.setString(
        "name",
        response.data["name"],
      );

      await prefs.setString(
        "email",
        response.data["user"]["email"],
      );
      print("TOKEN = $token");

      emit(LoginSuccessState());

    }catch (e) {

      if(e is DioException){

        emit(

          LoginErrorState(

            error:
            e.response?.data.toString()
                ?? "Login Failed",

          ),

        );

      }

    }
  }
}