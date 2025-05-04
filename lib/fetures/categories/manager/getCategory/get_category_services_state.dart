part of 'get_category_services_cubit.dart';

@immutable
sealed class GetCategoryServicesState {}

final class GetCategoryServicesInitial extends GetCategoryServicesState {}

final class GetCategoryServicesLoading extends GetCategoryServicesState {}

final class GetCategoryServicesSuccess extends GetCategoryServicesState {}

final class GetCategoryServicesFailure extends GetCategoryServicesState {
  final String errorMessage;
  GetCategoryServicesFailure({required this.errorMessage});
}
