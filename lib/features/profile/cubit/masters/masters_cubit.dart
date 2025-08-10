import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/profile/api_request/license_vahan_request.dart';
import 'package:gro_one_app/features/profile/repository/profile_repository.dart';
part 'masters_state.dart';



class MastersCubit extends BaseCubit<MastersState> {
  final ProfileRepository _repository;
  MastersCubit(this._repository) : super(MastersState.initial());



  void resetVehicleVerification() {
    emit(state.copyWith(
      vehicleVerification: UIState.initial(),
    ));
  }

    void resetLicenseVerification() {
    emit(state.copyWith(
      licenseVerification: UIState.initial(),
    ));
  }


  Future<Result<Map<String, dynamic>>> fetchAndVerifyVehicle(String vehicleNumber) async {
    emit(state.copyWith(vehicleVerification: UIState.loading()));

    final result = await _repository.fetchVehicleData(vehicleNumber);

    if (result is Success<Map<String, dynamic>>) {
      emit(state.copyWith(vehicleVerification: UIState.success(true)));
      return result;
    } else {
      emit(state.copyWith(vehicleVerification: UIState.error(GenericError())));
      return Error(GenericError());
    }
  }

    Future<Result<Map<String, dynamic>>> fetchAndVerifyLicense({required LicenseVahanRequest  licensereq}) async {
    emit(state.copyWith(licenseVerification: UIState.loading()));

    final result = await _repository.fetchLicenseData(licensereq: licensereq);

    if (result is Success<Map<String, dynamic>>) {
      emit(state.copyWith(licenseVerification: UIState.success(true)));
      return result;
    } else {
      emit(state.copyWith(licenseVerification: UIState.error(GenericError())));
      return Error(GenericError());
    }
  }
}
