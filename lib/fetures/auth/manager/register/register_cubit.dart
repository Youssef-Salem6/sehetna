import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/main.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register({required Map body}) async {
    emit(RegisterLoading());
    try {
      final response = await http.post(Uri.parse(registerApi), body: body);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        await _saveUserData(data);
        emit(RegisterSuccess(message: data["message"]));
      } else {
        emit(
            RegisterFailure(message: data["message"] ?? "Registration failed"));
      }
    } catch (e) {
      emit(RegisterFailure(message: "Network error: $e"));
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
