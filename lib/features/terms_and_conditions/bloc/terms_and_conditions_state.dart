part of 'terms_and_conditions_bloc.dart';

sealed class TermsAndConditionsState extends Equatable {
  const TermsAndConditionsState();
  
  @override
  List<Object> get props => [];
}

final class TermsAndConditionsInitial extends TermsAndConditionsState {}


class TermsAndCondtionsLoading extends TermsAndConditionsState {}

class TermsAndCondtionsSuccess extends TermsAndConditionsState {
  final TermsAndconditionsModel? termsAndconditionsModel;
  TermsAndCondtionsSuccess(this.termsAndconditionsModel);
}

class TermsAndCondtionsError extends TermsAndConditionsState {
  final ErrorType errorType;
  TermsAndCondtionsError(this.errorType);
}