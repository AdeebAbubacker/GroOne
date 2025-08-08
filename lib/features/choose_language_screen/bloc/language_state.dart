part of 'language_cubit.dart';

enum LanguageStatus { initial, loading, success, failure }

class LanguageState extends Equatable {
  final int index;
  final LanguageStatus status;
  final List<LanguageModel> languages;

  const LanguageState({
    this.index = 0,
    this.status = LanguageStatus.initial,
    this.languages = const [],
  });

  LanguageState copyWith({
    int? index,
    LanguageStatus? status,
    List<LanguageModel>? languages,
  }) {
    return LanguageState(
      index: index ?? this.index,
      status: status ?? this.status,
      languages: languages ?? this.languages,
    );
  }

  @override
  List<Object?> get props => [index, status, languages];
}
