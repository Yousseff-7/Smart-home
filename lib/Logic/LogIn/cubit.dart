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

      print(data);

      Response response = await dio.post(

        "http://64.225.101.222:5000/api/auth/login",

        data: data,

      );
      print("========== LOGIN RESPONSE ==========");
      print(response.data);
      print("====================================");
      print(response.statusCode);
      print("USER = ${response.data["user"]}");
      print("IMAGE = ${response.data["user"]?["image"]}");

      String token = response.data["token"];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool("isLogged", true);
      await prefs.setString("token", token);

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

      emit(LoginSuccessState());
    } catch (e) {

      print(e);

      if (e is DioException) {

        print(e.response?.statusCode);
        print(e.response?.data);


        emit(

          LoginErrorState(

            error: e.response?.data.toString() ?? e.message ?? "Login Failed",

          ),

        );

      }

    }

  }
}