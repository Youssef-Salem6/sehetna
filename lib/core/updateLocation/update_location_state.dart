part of 'update_location_cubit.dart';

@immutable
sealed class UpdateLocationState {}

final class UpdateLocationInitial extends UpdateLocationState {}

final class UpdateLocationSuccess extends UpdateLocationState {}

final class UpdateLocationFailure extends UpdateLocationState {}

final class UpdateLocationLoading extends UpdateLocationState {}
