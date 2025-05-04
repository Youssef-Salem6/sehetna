import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:http/http.dart' as http;
part 'feed_back_state.dart';

class FeedBackCubit extends Cubit<FeedBackState> {
  FeedBackCubit() : super(FeedBackInitial());
  submitFeedBack({
    required String rating,
    required String feedback,
    required String requestId,
  }) async {
    emit(FeedBackLoading());
    try {
      Uri url = Uri.parse("$getRequestsApi/$requestId/feedback");
      var response = await http.post(
        url,
        headers: header,
        body: {
          "rating": rating,
          "feedback": feedback,
        },
      );
      // Simulate a network request
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(FeedBackSuccess(message: jsonDecode(response.body)["message"]));
      } else {
        emit(FeedBackFailure(error: jsonDecode(response.body)["message"]));
      }
    } catch (e) {
      emit(FeedBackFailure(error: "unexpected error"));
    }
  }
}
