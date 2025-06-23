import 'package:equatable/equatable.dart';

class AssignDriverState extends Equatable {
  final bool isLoadAccepted;

  const AssignDriverState(this.isLoadAccepted);

  AssignDriverState copyWith({bool? isLoadAccepted}) {
    return AssignDriverState(isLoadAccepted ?? this.isLoadAccepted);
  }

  @override
  List<Object?> get props => [isLoadAccepted];
}
