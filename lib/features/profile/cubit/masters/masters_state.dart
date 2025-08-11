part of 'masters_cubit.dart';


class MastersState {
  final UIState<bool> vehicleVerification;
  final UIState<bool> licenseVerification;
  const MastersState({
    required this.vehicleVerification,
     required this.licenseVerification,
  });

  factory MastersState.initial() => MastersState(
    vehicleVerification: UIState.initial(),
    licenseVerification: UIState.initial(),
  );

  MastersState copyWith({
    UIState<bool>? vehicleVerification,
    UIState<bool>? licenseVerification,
  }) {
    return MastersState(
      vehicleVerification: vehicleVerification ?? this.vehicleVerification,
      licenseVerification: licenseVerification ?? this.licenseVerification,
    );
  }
}

