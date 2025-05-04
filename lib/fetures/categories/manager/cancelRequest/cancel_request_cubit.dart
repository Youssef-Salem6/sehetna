import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/constants/apis.dart';
part 'cancel_request_state.dart';

class CancelRequestCubit extends Cubit<CancelRequestState> {
  CancelRequestCubit() : super(CancelRequestInitial());

  cancelRequest({required String requestId, required String comment}) async {
    emit(CancelRequestLoading());
    try {
      final response =
          await http.post(Uri.parse("$getRequestsApi/$requestId/cancel"),
              body: {
                'reason': comment,
              },
              headers: header);
      if (response.statusCode == 200) {
        emit(CancelRequestSuccess(
            message: jsonDecode(response.body)['message']));
      } else {
        emit(CancelRequestFailure(jsonDecode(response.body)['message']));
      }
    } catch (e) {
      emit(CancelRequestFailure(e.toString()));
    }
  }
}
