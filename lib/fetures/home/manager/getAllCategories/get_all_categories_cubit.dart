import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/constants/apis.dart';
part 'get_all_categories_state.dart';

class GetAllCategoriesCubit extends Cubit<GetAllCategoriesState> {
  GetAllCategoriesCubit() : super(GetAllCategoriesInitial());

  List categories = [];
  getAllCategories() async {
    Uri url = Uri.parse(getAllCategoriesApi );
    emit(GetAllCategoriesLoading());
    try {
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        categories = jsonDecode(response.body)['data'];
        emit(GetAllCategoriesSuccess());
      } else {
        emit(GetAllCategoriesFailure());
      }
    } catch (e) {
      emit(GetAllCategoriesFailure());
    }
  }
}
