import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../utils/custom_log.dart';
import '../model/report_model.dart';


class GpsReportService {
  final ApiService _apiService;

  GpsReportService(this._apiService);

  Future<Result<List<Report>>> fetchReports({
    String? fromDate,
    String? toDate,
    int? vehicleId,
  }) async {
    try {
      final response = await _apiService.get(
        "https://api.letsgro.co/api/v1/reports", // Replace with actual endpoint
        queryParams: {
          "from_date": fromDate,
          "to_date": toDate,
          "vehicle_id": vehicleId,
        },
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => (data['data'] as List)
              .map((e) => Report.fromJson(e))
              .toList(),
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch reports", e);
      return Error(DeserializationError());
    }
  }
}
