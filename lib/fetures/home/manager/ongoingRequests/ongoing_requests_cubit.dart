import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:http/http.dart' as http;
part 'ongoing_requests_state.dart';

class OngoingRequestsCubit extends Cubit<OngoingRequestsState> {
  OngoingRequestsCubit() : super(OngoingRequestsInitial());

  List ongoingRequests = [];
  getOngoningRequests() async {
    print("start");
    emit(OngoingRequestsLoading());
    try {
      Uri uri = Uri.parse(getOngoingRequestsApi);
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        print("success");
        ongoingRequests = jsonDecode(response.body)["data"];
        if (ongoingRequests.isEmpty) {
          emit(OngoingRequestsEmpty());
        } else {
          emit(OngoingRequestsSuccess());
        }
      } else {
        emit(OngoingRequestsFailure(jsonDecode(response.body)["message"]));
      }
    } catch (e) {
      emit(OngoingRequestsFailure(e.toString()));
    }
  }
}
