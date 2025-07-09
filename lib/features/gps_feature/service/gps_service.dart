import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../utils/custom_log.dart';
import '../models/gps_geofence_model.dart';

class GpsService {
  final ApiService _apiService;

  GpsService(this._apiService);

  Future<Result<List<GpsGeofenceModel>>> fetchGeofences() async {
    try {
      final response = await _apiService.get(
        "https://api.letsgro.co/api/v1/auth/tc_geofences?__include=area&__include=attributes&__limit=10000",
        customHeaders: {
          'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NTE5NTA4MDUsIm5iZiI6MTc1MTk1MDgwNSwianRpIjoiYTkzODkzYmQtZDQ2MS00YjZmLTk0MGItODdkY2E0MWY3ZDQyIiwiZXhwIjoxNzUyMjEwMDA1LCJpZGVudGl0eSI6eyJpZCI6MTYzLCJkYiI6MSwiY28iOjEsIm5hbWUiOiJ0ZXNyIiwidHlwZSI6ImFkbWluIiwicmVhZF9vbmx5IjowLCJ0eiI6LTMzMCwidHpfcyI6IkFzaWEvS29sa2F0YSIsInNzbyI6MCwiZGV2aWNlIjoibW9iaWxlIiwiYWxpYXMiOiIifSwiZnJlc2giOmZhbHNlLCJ0eXBlIjoiYWNjZXNzIn0.JhBN5XDxDlWdXwBjGIxFfZi61sV_okgfwX4KmS-RxVQ',
        },
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => (data['data'] as List)
              .map((e) => GpsGeofenceModel.fromJson(e))
              .toList(),
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch geofences", e);
      return Error(DeserializationError());
    }
  }
}

