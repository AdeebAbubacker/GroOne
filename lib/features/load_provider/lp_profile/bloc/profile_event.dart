part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}
class ProfileUpdateRequested extends ProfileEvent {
  final ProfileUpdateRequest apiRequest;
  final String  userID;

    ProfileUpdateRequested({required this.apiRequest,required this.userID});
}