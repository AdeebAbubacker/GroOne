part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}
class ProfileUpdateLoading extends ProfileState{}
class MasterLoading extends ProfileState{}
class ProfileImageUploadLoading extends ProfileState{}
class ProfileUpdateSuccess extends ProfileState{
  final ProfileUpdateResponse profileUpdateResponse;
  ProfileUpdateSuccess(this.profileUpdateResponse,);
}class GetMasterSuccess extends ProfileState{
  final MasterResponse masterResponse;
  GetMasterSuccess(this.masterResponse,);
}class ProfileUploadedSuccess extends ProfileState{
  final ProfileImageUploadResponse profileImageUploadResponse;
  ProfileUploadedSuccess(this.profileImageUploadResponse,);
}
class ProfileUpdateError extends ProfileState {
  final ErrorType errorType;

  ProfileUpdateError(this.errorType);
}
