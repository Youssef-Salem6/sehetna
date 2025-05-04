part of 'feed_back_cubit.dart';

@immutable
sealed class FeedBackState {}

final class FeedBackInitial extends FeedBackState {}

final class FeedBackSuccess extends FeedBackState {
  final String message;
  FeedBackSuccess({required this.message});
}

final class FeedBackLoading extends FeedBackState {}

final class FeedBackFailure extends FeedBackState {
  final String error;
  FeedBackFailure({required this.error});
}
