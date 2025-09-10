import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:http/http.dart' as http;
part 'appointment_details_state.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  AppointmentDetailsCubit() : super(AppointmentDetailsInitial());
  Map data = {};
  getRequestDetails({required String id}) async {
    emit(AppointmentDetailsLoading());
    Uri url = Uri.parse("$getRequestsApi/$id");
    try {
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        data = jsonDecode(response.body)["data"];
        emit(AppointmentDetailsSuccess());
      } else {
        emit(AppointmentDetailsFailure(
            error: jsonDecode(response.body)["message"]));
      }
    } catch (e) {
      emit(AppointmentDetailsFailure(error: "unexpected error"));
    }
  }
}
