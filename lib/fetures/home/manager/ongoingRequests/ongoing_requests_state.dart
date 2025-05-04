part of 'ongoing_requests_cubit.dart';

@immutable
sealed class OngoingRequestsState {}

final class OngoingRequestsInitial extends OngoingRequestsState {}

final class OngoingRequestsSuccess extends OngoingRequestsState {}

final class OngoingRequestsFailure extends OngoingRequestsState {
  final String errorMessage;
  OngoingRequestsFailure(this.errorMessage);
}

final class OngoingRequestsLoading extends OngoingRequestsState {}

final class OngoingRequestsEmpty extends OngoingRequestsState {}
