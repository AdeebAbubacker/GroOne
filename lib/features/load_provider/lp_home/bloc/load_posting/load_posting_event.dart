part of 'load_posting_bloc.dart';

@immutable
sealed class LoadPostingEvent {}

/// Create Load Post
class CreateLoadPostingEvent extends LoadPostingEvent {
  final CreateLoadApiRequest apiRequest;
  CreateLoadPostingEvent({required this.apiRequest});
}

