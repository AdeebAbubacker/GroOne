part of 'lp_home_bloc.dart';

@immutable
sealed class HomeEvent {}
class GetProfileDetailApiRequest extends HomeEvent {
  final  String userId;
  GetProfileDetailApiRequest(this.userId);
}