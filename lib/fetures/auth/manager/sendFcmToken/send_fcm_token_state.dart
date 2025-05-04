part of 'send_fcm_token_cubit.dart';

@immutable
sealed class SendFcmTokenState {}

final class SendFcmTokenInitial extends SendFcmTokenState {}

final class SendFcmTokenSuccess extends SendFcmTokenState {}

final class SendFcmTokenLoading extends SendFcmTokenState {}

final class SendFcmTokenFailure extends SendFcmTokenState {}
