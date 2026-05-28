import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled55/Logic/SignUp/states.dart';
import 'package:untitled55/Models/user_model.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  final dio = Dio();

  Future signUp(String userName, String userEmail, String userPass) async {
    emit(SignUpLoadingState());

    try {
      UserModel userModel = UserModel(
        name: userName,
        email: userEmail,
        password: userPass,
      );

      Response response = await dio.post(
        'http://64.225.101.222:5000/api/auth/register',
        data: userModel.toJson(),
      );

      String token = response.data["token"];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool("isLogged", true);
      await prefs.setString("name", userName);
      await prefs.setString("email", userEmail);
      await prefs.setString("token", token);

      emit(SignUpSuccessState());

    }catch (e) {
      if (e is DioException) {
        print("STATUS CODE: ${e.response?.statusCode}");
        print("RESPONSE DATA: ${e.response?.data}");
        print("REQUEST DATA: ${e.requestOptions.data}");

        emit(
          SignUpErrorState(
            em: e.response?.data.toString() ?? e.message.toString(),
          ),
        );
      } else {
        emit(SignUpErrorState(em: e.toString()));
      }
    }
  }
}