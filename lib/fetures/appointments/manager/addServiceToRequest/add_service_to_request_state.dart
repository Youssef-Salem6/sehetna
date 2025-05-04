part of 'add_service_to_request_cubit.dart';

@immutable
sealed class AddServiceToRequistState {}

final class AddServiceToRequistInitial extends AddServiceToRequistState {}

final class AddServiceToRequistLoading extends AddServiceToRequistState {}

final class AddServiceToRequistSuccess extends AddServiceToRequistState {
  final String message;

  AddServiceToRequistSuccess({required this.message});
}

final class AddServiceToRequistFailure extends AddServiceToRequistState {
  final String errorMessage;

  AddServiceToRequistFailure({required this.errorMessage});
}
