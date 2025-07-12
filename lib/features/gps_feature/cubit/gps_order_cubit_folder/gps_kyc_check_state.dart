part of 'gps_kyc_check_cubit.dart';

class GpsKycCheckState extends Equatable {
  final UIState<GpsKycCheckModel>? kycCheckState;
  final bool hasKycDocuments;
  final Map<String, dynamic>? kycData;

  const GpsKycCheckState({
    this.kycCheckState,
    this.hasKycDocuments = false,
    this.kycData,
  });

  factory GpsKycCheckState.initial() {
    return const GpsKycCheckState();
  }

  GpsKycCheckState copyWith({
    UIState<GpsKycCheckModel>? kycCheckState,
    bool? hasKycDocuments,
    Map<String, dynamic>? kycData,
  }) {
    return GpsKycCheckState(
      kycCheckState: kycCheckState ?? this.kycCheckState,
      hasKycDocuments: hasKycDocuments ?? this.hasKycDocuments,
      kycData: kycData ?? this.kycData,
    );
  }

  @override
  List<Object?> get props => [
    kycCheckState,
    hasKycDocuments,
    kycData,
  ];
} 