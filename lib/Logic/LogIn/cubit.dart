import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled55/Logic/LogIn/states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());


  Future login(String userEmail, String userPass) async {
    emit(LoginLoadingState());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: userPass,
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLogged", true);







      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState());
    }
  }
}
