part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final ProfileUpdateRequest apiRequest;
  final String userID;

  ProfileUpdateRequested({required this.apiRequest, required this.userID});
}

class MasterRequested extends ProfileEvent {
  final String userID;

  MasterRequested({required this.userID});
}
class ProfileImageUploadRequested extends ProfileEvent {
  final ProfileImageUploadRequest profileImageUploadRequest;
 final String userId;

  ProfileImageUploadRequested({required this.profileImageUploadRequest,required this.userId});
}
