part of 'submit_complain_cubit.dart';

@immutable
sealed class SubmitComplainState {}

final class SubmitComplainInitial extends SubmitComplainState {}

final class SubmitComplainLoading extends SubmitComplainState {}

final class SubmitComplainSuccess extends SubmitComplainState {
  final String message;
  SubmitComplainSuccess({required this.message});
}

final class SubmitComplainFailure extends SubmitComplainState {
  final String error;
  SubmitComplainFailure({required this.error});
}
