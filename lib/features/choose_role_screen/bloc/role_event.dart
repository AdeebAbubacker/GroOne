part of 'role_bloc.dart';

@immutable
sealed class RoleEvent extends Equatable {
  const RoleEvent();

  @override
  List<Object?> get props => [];
}


class ChangeIndex extends RoleEvent{
  final int index;

  const ChangeIndex({ required this.index});
}