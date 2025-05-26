part of 'lp_create_bloc.dart';

@immutable
sealed class LpCreateState {}

final class LpCreateInitial extends LpCreateState {}

class LpCreateLoading extends LpCreateState {}

class LpCreateSuccess extends LpCreateState {
  final CreateResponse createResponse;

  LpCreateSuccess(this.createResponse);
}

class LpCompanyTypeSuccess extends LpCreateState {
  final LpCompanyTypeResponse lpCompanyTypeSuccess;

  LpCompanyTypeSuccess(this.lpCompanyTypeSuccess);
}

class LpCreateError extends LpCreateState {
  final ErrorType errorType;

  LpCreateError(this.errorType);
}
