import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/constants/apis.dart';
part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  deleteAccount() async {
    emit(DeleteAccountLoading());
    Uri url = Uri.parse(deleteAccountApi);
    var response = await http.post(url, headers: header);
    if (response.statusCode == 200) {
      emit(DeleteAccountSuccess());
    } else {
      emit(DeleteAccountFailure(message: jsonDecode(response.body)["message"]));
    }
  }
}
