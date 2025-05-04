import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/constants/apis.dart';
part 'submit_complain_state.dart';

class SubmitComplainCubit extends Cubit<SubmitComplainState> {
  SubmitComplainCubit() : super(SubmitComplainInitial());
  submitComplain(
      {required String requestId,
      required String subject,
      required String description}) async {
    emit(SubmitComplainLoading());
    try {
      Uri url = Uri.parse("$getRequestsApi/$requestId/complaint");
      var response = await http.post(url, headers: header, body: {
        "subject": subject,
        "description": description,
      });
      var data = jsonDecode(response.body);
      String message = data['message'];
      if (response.statusCode == 200) {
        emit(SubmitComplainSuccess(message: message));
      } else {
        emit(SubmitComplainFailure(error: message));
      }
    } catch (e) {
      emit(SubmitComplainFailure(error: "unexpected error"));
    }
  }
}
