part of 'privacy_policy_bloc.dart';

sealed class PrivacyPolicyState extends Equatable {
  const PrivacyPolicyState();
  
  @override
  List<Object> get props => [];
}

final class PrivacyPolicyInitial extends PrivacyPolicyState {}


class PrivacyPolicyLoading extends PrivacyPolicyState {}

class PrivacyPolicySuccess extends PrivacyPolicyState {
  final PrivacyDetailsModel? privacyDetailsModel;
  const PrivacyPolicySuccess(this.privacyDetailsModel);
}

class PrivacyPolicyError extends PrivacyPolicyState {
  final ErrorType errorType;
  const PrivacyPolicyError(this.errorType);
}