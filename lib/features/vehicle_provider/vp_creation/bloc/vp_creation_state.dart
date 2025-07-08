part of 'vp_creation_bloc.dart';

sealed class VpCreationState {}

/// Vp Creation State
class VpCreationInitial extends VpCreationState {}

class VpCreationLoading extends VpCreationState {}

class VpCreationSuccess extends VpCreationState {
  final UserModel? vpCreationModel;
  VpCreationSuccess(this.vpCreationModel);
}

class VpCreationError extends VpCreationState {
  final ErrorType errorType;
  VpCreationError(this.errorType);
}
sealed class VpCompanyTypeState {}

/// Vp Company Type State
class VpCompanyTypeInitial extends VpCreationState {}

class VpCompanyTypeLoading extends VpCreationState {}

class VpCompanyTypeSuccess extends VpCreationState {
  final List<VpCompanyTypeModel> companyType;
  VpCompanyTypeSuccess(this.companyType);
}

class VpCompanyTypeError extends VpCreationState {
  final ErrorType errorType;
  VpCompanyTypeError(this.errorType);
}


class LogoutError extends VpCreationState {
  final ErrorType errorType;
  LogoutError(this.errorType);
}

// Truck Type state
class TruckTypeInitial extends VpCreationState {}
class TruckTypeLoading extends VpCreationState {}
class TruckTypeSuccess extends VpCreationState {
  final TruckTypeModel truckTypeModel;
  TruckTypeSuccess(this.truckTypeModel);
}
class TruckTypeError extends VpCreationState {
  final ErrorType errorType;
  TruckTypeError(this.errorType);
}

// Preffered Truck Lane state
class TruckPrefLaneInitial extends VpCreationState {}
class TruckPrefLaneLoading extends VpCreationState {}
class TruckPrefLaneSuccess extends VpCreationState {
  final TruckPrefLaneModel truckPrefLaneModel;
  TruckPrefLaneSuccess(this.truckPrefLaneModel);
}
class TruckPrefLaneError extends VpCreationState {
  final ErrorType errorType;
  TruckPrefLaneError(this.errorType);
}


