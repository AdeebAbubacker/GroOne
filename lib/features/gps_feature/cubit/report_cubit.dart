import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';

import '../../../../data/model/result.dart';
import '../../../dependency_injection/locator.dart';
import '../model/report_model.dart';
import '../repository/report_repository.dart';

part 'report_state.dart';

class GpsReportCubit extends BaseCubit<GpsReportState> {
  final GpsReportRepository _repository;

  GpsReportCubit({GpsReportRepository? repository})
      : _repository = repository ?? locator<GpsReportRepository>(),
        super(GpsReportState());

  Future<void> loadReports({
    String? fromDate,
    String? toDate,
    int? vehicleId,
  }) async {
    emit(ReportLoading());
    final result = await _repository.fetchReports(
      fromDate: fromDate,
      toDate: toDate,
      vehicleId: vehicleId,
    );

    if (result is Success<List<Report>>) {
      emit(ReportLoaded(result.value));
    } else if (result is Error<List<Report>>) {
      emit(ReportError(result.type.toString()));
    }
  }
}
