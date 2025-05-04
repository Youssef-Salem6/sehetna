part of 'update_profile_image_cubit.dart';

@immutable
abstract class UpdateProfileImageState {}

class UpdateProfileImageInitial extends UpdateProfileImageState {}

class UpdateProfileImageLoading extends UpdateProfileImageState {}

class UpdateProfileImageSuccess extends UpdateProfileImageState {
  final String imageUrl;

  UpdateProfileImageSuccess({required this.imageUrl});
}

class UpdateProfileImageFailure extends UpdateProfileImageState {
  final String error;

  UpdateProfileImageFailure({required this.error});
}
