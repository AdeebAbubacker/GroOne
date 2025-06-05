part of 'lp_home_bloc.dart';

@immutable
sealed class HomeEvent {}
class ProfileDetailRequested extends HomeEvent {
  final  String userId;
  ProfileDetailRequested(this.userId);
}