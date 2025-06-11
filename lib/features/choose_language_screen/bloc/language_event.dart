part of 'language_bloc.dart';

@immutable
sealed class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}


class ChangeIndex extends LanguageEvent{
  final int index;

  const ChangeIndex({ required this.index});
}

class LoadLanguages extends LanguageEvent {}
