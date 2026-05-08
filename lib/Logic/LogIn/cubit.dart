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

      await dio.post(
        'http://64.225.101.222:5000/api/auth/login',
        data: data,
      );
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool("isLogged", true);
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState());
    }
  }
}