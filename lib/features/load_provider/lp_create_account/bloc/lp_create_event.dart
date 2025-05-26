part of 'lp_create_bloc.dart';

@immutable
sealed class LpCreateEvent {}

class LpCreateRequested extends LpCreateEvent {
  final CreateRequest apiRequest;
  final String id;

  LpCreateRequested({required this.apiRequest, required this.id});
}

class LpCompanyTypeRequested extends LpCreateEvent {
  LpCompanyTypeRequested();
}
