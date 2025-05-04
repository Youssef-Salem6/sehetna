import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';

import 'package:http/http.dart' as http;
part 'get_complaints_state.dart';

class GetComplaintsCubit extends Cubit<GetComplaintsState> {
  GetComplaintsCubit() : super(GetComplaintsInitial());

  List complaints = [];
  getComplaints({required String id}) async {
    Uri url = Uri.parse("$getRequestsApi/$id/complaints");
    try {
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        complaints = jsonDecode(response.body)["data"];
        emit(GetComplaintsSuccess());
      } else {
        emit(GetComplaintsFailure(
            errorMessage: jsonDecode(response.body)["message"]));
      }
    } catch (e) {
      emit(GetComplaintsFailure(errorMessage: e.toString()));
    }
  }
}
