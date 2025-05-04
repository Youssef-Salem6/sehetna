part of 'get_complaints_cubit.dart';

@immutable
sealed class GetComplaintsState {}

final class GetComplaintsInitial extends GetComplaintsState {}

final class GetComplaintsLoading extends GetComplaintsState {}

final class GetComplaintsFailure extends GetComplaintsState {
  final String errorMessage;
  GetComplaintsFailure({required this.errorMessage});
}

final class GetComplaintsSuccess extends GetComplaintsState {}
