part of 'cancel_request_cubit.dart';

@immutable
sealed class CancelRequestState {}

final class CancelRequestInitial extends CancelRequestState {}

final class CancelRequestSuccess extends CancelRequestState {
  final String message;
  CancelRequestSuccess({required this.message});
}

final class CancelRequestFailure extends CancelRequestState {
  final String errorMessage;
  CancelRequestFailure(this.errorMessage);
}

final class CancelRequestLoading extends CancelRequestState {}
