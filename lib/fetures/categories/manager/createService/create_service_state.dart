part of 'create_service_cubit.dart';

@immutable
sealed class CreateServiceState {}

final class CreateServiceInitial extends CreateServiceState {}

final class CreateServiceLoading extends CreateServiceState {}

final class CreateServiceSuccess extends CreateServiceState {
  final String requestId;
  CreateServiceSuccess({required this.requestId});
}

final class CreateServiceFailure extends CreateServiceState {
  final String errorMessage;
  CreateServiceFailure(this.errorMessage);
}
