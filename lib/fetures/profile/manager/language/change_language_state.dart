part of 'change_language_cubit.dart';

@immutable
sealed class ChangeLanguageState {}

final class ChangeLanguageInitial extends ChangeLanguageState {
  final String currentLanguage;
  ChangeLanguageInitial(this.currentLanguage);
}

final class ChangeLanguageSuccess extends ChangeLanguageState {
  final String languageCode;
  ChangeLanguageSuccess(this.languageCode);
}

final class ChangeLanguageLoading extends ChangeLanguageState {}

final class ChangeLanguageFailure extends ChangeLanguageState {}
