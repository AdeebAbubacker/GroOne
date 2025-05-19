
part of 'language_bloc.dart';



enum CounterStatus { initial, isLoading, isSuccess, isFailed }

class LanguageState extends Equatable {
  const LanguageState({this.index = 0, this.status = CounterStatus.initial});

  final int index;
  final CounterStatus status;

  LanguageState copyWith({int? counter, CounterStatus? status}) => LanguageState(
    index: counter ?? this.index,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [index, status];
}