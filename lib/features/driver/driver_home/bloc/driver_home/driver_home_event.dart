part of 'driver_home_bloc.dart';



@immutable
sealed class DriverHomeEvent {}
class GetProfileDetailApiRequest extends DriverHomeEvent {
  final  String userId;
  GetProfileDetailApiRequest(this.userId);
}