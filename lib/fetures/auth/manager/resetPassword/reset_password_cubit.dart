import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:http/http.dart' as http;
part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());
  resetPassword({
    required String email,
    required String password,
    required String confirmationPassword,
  }) async {
    emit(ResetPasswordLoading());
    Uri url = Uri.parse(resetPasswordApi);
    var response = await http.post(url, body: {
      "email": email,
      "password": password,
      "password_confirmation": confirmationPassword,
    });
    if (response.statusCode == 200) {
      emit(ResetPasswordSuccess(message: jsonDecode(response.body)["message"]));
    } else {
      emit(ResetPasswordFailure(
          errorMessage: jsonDecode(response.body)["message"]));
    }
  }
}
