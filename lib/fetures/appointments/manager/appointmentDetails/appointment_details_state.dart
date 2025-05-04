part of 'appointment_details_cubit.dart';

@immutable
sealed class AppointmentDetailsState {}

final class AppointmentDetailsInitial extends AppointmentDetailsState {}

final class AppointmentDetailsSuccess extends AppointmentDetailsState {}

final class AppointmentDetailsLoading extends AppointmentDetailsState {}

final class AppointmentDetailsFailure extends AppointmentDetailsState {
  final String? error;
  AppointmentDetailsFailure({required this.error});
}
