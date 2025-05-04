import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/constants/apis.dart';
part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  changePassword({required Map body}) async {
    emit(ChangePasswordLoading());
    Uri url = Uri.parse(updatePasswordApi);
    var response = await http.post(url, body: body, headers: header);
    if (response.statusCode == 200) {
      emit(
          ChangePasswordSuccess(message: jsonDecode(response.body)["message"]));
    } else {
      emit(ChangePasswordFailure(error: jsonDecode(response.body)["message"]));
    }
  }
}
