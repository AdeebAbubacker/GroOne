import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'lp_create_event.dart';
part 'lp_create_state.dart';

class LpCreateBloc extends Bloc<LpCreateEvent, LpCreateState> {
  LpCreateBloc() : super(LpCreateInitial()) {
    on<LpCreateEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
