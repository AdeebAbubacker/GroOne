import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/sign_in/api_request/sign_in_api_request.dart';
import 'package:gro_one_app/features/sign_in/model/sign_in_model.dart';
import 'package:gro_one_app/features/sign_in/repository/sign_in_repository.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRepository _repository;

  SignInBloc(this._repository) : super(SignInInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(SignInLoading());
      Result result = await _repository.requestSignIn(event.apiRequest);
      if (result is Success<SignInModel>) {
        emit(SignInSuccess(result.value));
      } else if (result is Error) {
        emit(SignInError(result.type));
      } else {
        emit(SignInError(GenericError()));
      }
    });
  }

}
