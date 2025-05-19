
part of 'role_bloc.dart';



enum RoleStatus { initial, isLoading, isSuccess, isFailed }

class RoleState extends Equatable {
  const RoleState({this.index = 0, this.status = RoleStatus.initial});

  final int index;
  final RoleStatus status;

  RoleState copyWith({int? counter, RoleStatus? status}) => RoleState(
    index: counter ?? this.index,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [index, status];
}