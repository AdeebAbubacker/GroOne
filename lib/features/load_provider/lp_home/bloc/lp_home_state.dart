part of 'lp_home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
class ProfileLoading extends HomeState {}
class ProfileDetailSuccess extends HomeState {
  final ProfileDetailResponse profileDetailResponse;

  ProfileDetailSuccess(this.profileDetailResponse);
}

class ProfileDetailError extends HomeState {
  final ErrorType errorType;

  ProfileDetailError(this.errorType);
}
