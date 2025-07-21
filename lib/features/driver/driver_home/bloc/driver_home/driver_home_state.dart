part of 'driver_home_bloc.dart';


@immutable
sealed class DriverHomeState {}

final class HomeInitial extends DriverHomeState {}
class ProfileLoading extends DriverHomeState {}
class ProfileDetailSuccess extends DriverHomeState {
  final ProfileDetailModel profileDetailResponse;

  ProfileDetailSuccess(this.profileDetailResponse);
}

class ProfileDetailError extends DriverHomeState {
  final ErrorType errorType;

  ProfileDetailError(this.errorType);
}
