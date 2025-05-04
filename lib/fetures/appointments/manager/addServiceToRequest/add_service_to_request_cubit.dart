import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:http/http.dart' as http;
part 'add_service_to_request_state.dart';

class AddServiceToRequistCubit extends Cubit<AddServiceToRequistState> {
  AddServiceToRequistCubit() : super(AddServiceToRequistInitial());

  addServiceToRequist({
    required String requestId,
    required List selectedServices,
  }) async {
    try {
      Uri url = Uri.parse("$getRequestsApi/$requestId/add-service");

      var response = await http.post(
        url,
        headers: header,
        body: {"service_ids": selectedServices.toString()},
      );

      if (response.statusCode == 200) {
        emit(AddServiceToRequistSuccess(
          message: jsonDecode(response.body)["message"],
        ));
      } else {
        emit(AddServiceToRequistFailure(
          errorMessage: jsonDecode(response.body)["message"],
        ));
      }
    } on Exception catch (e) {
      emit(
        AddServiceToRequistFailure(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
