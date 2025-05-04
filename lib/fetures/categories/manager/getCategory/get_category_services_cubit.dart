import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/constants/apis.dart';
part 'get_category_services_state.dart';

class GetCategoryServicesCubit extends Cubit<GetCategoryServicesState> {
  GetCategoryServicesCubit() : super(GetCategoryServicesInitial());
  List services = [];
  getCategoryServices({required String id}) async {
    emit(GetCategoryServicesLoading());
    Uri url = Uri.parse("$getAllCategoriesApi/$id/services");
    try {
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        services = jsonDecode(response.body)["data"]["services"];
        emit(GetCategoryServicesSuccess());
      } else {
        emit(GetCategoryServicesFailure(
            errorMessage: jsonDecode(response.body)["message"]));
      }
    } catch (e) {
      emit(GetCategoryServicesFailure(errorMessage: e.toString()));
    }
  }
}
