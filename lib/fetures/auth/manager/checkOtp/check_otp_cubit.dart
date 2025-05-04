import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/constants/apis.dart';
part 'check_otp_state.dart';

class CheckOtpCubit extends Cubit<CheckOtpState> {
  CheckOtpCubit() : super(CheckOtpInitial());
  checkCode({required String email, required String code}) async {
    emit(CheckOtpLoading());
    Uri url = Uri.parse(otpApi);
    var response = await http.post(url, body: {
      "email": email,
      "reset_code": code,
    });
    if (response.statusCode == 200) {
      emit(CheckOtpSuccess(message: jsonDecode(response.body)["message"]));
    } else {
      emit(CheckOtpFailure(error: jsonDecode(response.body)["message"]));
    }
  }
}
