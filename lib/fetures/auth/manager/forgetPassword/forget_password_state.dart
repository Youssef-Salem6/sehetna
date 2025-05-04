part of 'forget_password_cubit.dart';

@immutable
sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  final String message;

  ForgetPasswordSuccess({required this.message});
}

final class ForgetPasswordLoading extends ForgetPasswordState {}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String message;

  ForgetPasswordFailure({required this.message});
}
