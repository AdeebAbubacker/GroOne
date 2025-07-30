import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';

part 'gps_kyc_check_state.dart';

class GpsKycCheckCubit extends Cubit<GpsKycCheckState> {
  final GpsOrderApiRepository _repository;
  bool _isClosed = false;

  GpsKycCheckCubit(this._repository) : super(GpsKycCheckState.initial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(GpsKycCheckState.initial());
  }

  /// Check if KYC documents exist for the customer
  Future<void> checkKycDocuments(String customerId) async {
    if (_isClosed) return;

    _setKycCheckUIState(UIState.loading());

    try {
      final result = await _repository.checkKycDocuments(customerId);

      if (_isClosed) return; // Check again after async operation

      if (result is Success<GpsKycCheckResponseModel>) {
        final kycModel = result.value;
        final hasDocuments = kycModel.hasKycDocuments;

        emit(
          state.copyWith(
            hasKycDocuments: hasDocuments,
            kycData: kycModel.documents != null ? {
              'customerId': kycModel.customerId,
              'isKyc': kycModel.isKyc,
              'documents': {
                'aadhar': kycModel.documents!.aadhar,
                'isAadhar': kycModel.documents!.isAadhar,
                'pan': kycModel.documents!.pan,
                'panDocLink': kycModel.documents!.panDocLink,
                'isPan': kycModel.documents!.isPan,
              }
            } : null,
          ),
        );
        _setKycCheckUIState(UIState.success(kycModel));
      } else if (result is Error) {
        _setKycCheckUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      if (!_isClosed) {
        _setKycCheckUIState(UIState.error(GenericError()));
      }
    }
  }

  /// Sets the KYC check UI state
  void _setKycCheckUIState(UIState<GpsKycCheckResponseModel>? uiState) {
    if (!_isClosed) {
      emit(state.copyWith(kycCheckState: uiState));
    }
  }
} 