import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:http/http.dart' as http;
part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  updateProfile({required Map body}) async {
    Uri url = Uri.parse(updateProfileApi);
    emit(UpdateProfileLoading());
    try {
      var response = await http.post(
        url,
        headers: header,
        body: body,
      );
      if (response.statusCode == 200) {
        emit(UpdateProfileSuccess(
            message: jsonDecode(response.body)["message"]));
      } else {
        emit(UpdateProfileFailure(error: jsonDecode(response.body)["message"]));
      }
    } catch (e) {
      print(e);
      emit(UpdateProfileFailure(error: "unexpected error"));
    }
  }
}
