part of 'load_posting_bloc.dart';

@immutable
sealed class LoadPostingState {}

final class LoadPostingInitial extends LoadPostingState {}


/// Create Load Post State
class CreateLoadPostInitial extends LoadPostingState {}

class CreateLoadLoading extends LoadPostingState {}

class CreateLoadSuccess extends LoadPostingState {
  final CreateLoadModel createLoadModel;
  CreateLoadSuccess(this.createLoadModel);
}

class CreateLoadError extends LoadPostingState {
  final ErrorType errorType;
  CreateLoadError(this.errorType);
}