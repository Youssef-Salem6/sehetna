import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'change_language_state.dart';

class ChangeLanguageCubit extends Cubit<ChangeLanguageState> {
  ChangeLanguageCubit() : super(ChangeLanguageInitial('en'));

  Future<void> changeLanguage(String languageCode) async {
    emit(ChangeLanguageLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', languageCode);
      emit(ChangeLanguageSuccess(languageCode));
    } catch (e) {
      emit(ChangeLanguageFailure());
    }
  }
}