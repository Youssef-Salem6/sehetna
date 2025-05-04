import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/main.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await http.post(
        Uri.parse(loginApi),
        body: {"email": email, "password": password, "user_type": "customer"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveUserData(data);
        emit(LoginSuccess(message: data["message"]));
      } else {
        emit(LoginFailure(message: data["message"] ?? "Login failed"));
      }
    } catch (e) {
      emit(LoginFailure(message: "Network error: $e"));
    }
  }

  Future<void> _saveUserData(Map data) async {
    await pref.setString("id", data["data"]["user"]["id"].toString());
    await pref.setString("email", data["data"]["user"]["email"]);
    await pref.setString("firstName", data["data"]["user"]["first_name"]);
    await pref.setString("lastName", data["data"]["user"]["last_name"]);
    await pref.setString("gender", data["data"]["user"]["gender"]);
    await pref.setString("phone", data["data"]["user"]["phone"]);
    await pref.setString("address", data["data"]["user"]["address"]);
    await pref.setString("image", data["data"]["user"]["profile_image"] ?? "");
    await pref.setString("token", data["data"]["token"]);
    await pref.setBool("isFirstTime", false);
  }
}
