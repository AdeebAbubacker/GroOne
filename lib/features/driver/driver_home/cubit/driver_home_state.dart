part of 'driver_home_cubit.dart';

// sealed class DriverHomeState extends Equatable {
//   const DriverHomeState();

//   @override
//   List<Object> get props => [];
// }

// final class DriverHomeInitial extends DriverHomeState {}


class DriverHomeState extends Equatable {
  final bool? isFilterApplied;

  const DriverHomeState({
    this.isFilterApplied,
  });

  DriverHomeState copyWith({
    bool? isFilterApplied,
  }) {
    return DriverHomeState(
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
    );
  }

  @override
  List<Object?> get props => [
    isFilterApplied,
  ];
}
