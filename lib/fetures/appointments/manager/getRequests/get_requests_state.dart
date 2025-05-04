part of 'get_requests_cubit.dart';

@immutable
abstract class GetRequestsState {}

class GetRequestsInitial extends GetRequestsState {}

class GetRequestsLoading extends GetRequestsState {}

class GetRequestsSuccess extends GetRequestsState {}

class GetRequestsEmpty extends GetRequestsState {}

class GetRequestsFailure extends GetRequestsState {
  final String error;
  GetRequestsFailure({required this.error});
}
