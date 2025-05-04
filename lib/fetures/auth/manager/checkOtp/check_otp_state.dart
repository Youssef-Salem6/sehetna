part of 'check_otp_cubit.dart';

@immutable
sealed class CheckOtpState {}

final class CheckOtpInitial extends CheckOtpState {}

final class CheckOtpLoading extends CheckOtpState {}

final class CheckOtpSuccess extends CheckOtpState {
  final String message;
  CheckOtpSuccess({required this.message});
}

final class CheckOtpFailure extends CheckOtpState {
  final String error;
  CheckOtpFailure({required this.error});
}
