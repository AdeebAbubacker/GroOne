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
    print('🔒 GpsKycCheckCubit.close() called');
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    print('🔄 Resetting GpsKycCheckCubit state');
    _isClosed = false;
    emit(GpsKycCheckState.initial());
  }

  /// Check if KYC documents exist for the customer
  Future<void> checkKycDocuments(String customerId) async {
    print('🔍 GpsKycCheckCubit.checkKycDocuments called');
    print('🔍 Cubit closed status: $_isClosed');
    print('🔍 Customer ID: $customerId');

    if (_isClosed) return;

    print('🔍 Starting GPS KYC documents check...');
    _setKycCheckUIState(UIState.loading());

    try {
      final result = await _repository.checkKycDocuments(customerId);

      if (_isClosed) return; // Check again after async operation

      if (result is Success<GpsKycCheckModel>) {
        final kycModel = result.value;
        final hasDocuments = kycModel.hasKycDocuments;

        print('📋 GPS KYC Check Response:');
        print('  Success: ${kycModel.success}');
        print('  Message: ${kycModel.message}');
        print('  Data Type: ${kycModel.data.runtimeType}');
        print('  Data: ${kycModel.data}');
        print('  Has Documents: $hasDocuments');
        print('  KYC Data: ${kycModel.kycData}');

        emit(
          state.copyWith(
            hasKycDocuments: hasDocuments,
            kycData: kycModel.kycData,
          ),
        );
        _setKycCheckUIState(UIState.success(kycModel));
      } else if (result is Error) {
        print('❌ GPS KYC Check failed: ${(result as Error).type}');
        _setKycCheckUIState(UIState.error((result as Error).type));
      }
    } catch (e) {
      print('💥 GPS KYC Check exception: $e');
      if (!_isClosed) {
        _setKycCheckUIState(UIState.error(GenericError()));
      }
    }
  }

  /// Sets the KYC check UI state
  void _setKycCheckUIState(UIState<GpsKycCheckModel>? uiState) {
    if (!_isClosed) {
      emit(state.copyWith(kycCheckState: uiState));
    }
  }
} 