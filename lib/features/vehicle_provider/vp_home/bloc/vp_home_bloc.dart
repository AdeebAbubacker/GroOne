import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vp_home_event.dart';
part 'vp_home_state.dart';

class VpHomeBloc extends Bloc<VpHomeEvent, VpHomeState> {
  VpHomeBloc() : super(VpHomeInitial()) {
    on<VpHomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
