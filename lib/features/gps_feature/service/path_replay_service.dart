import 'package:dio/dio.dart';

import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../model/path_positions_pojo.dart';
import '../model/trip_path_model.dart';

class PathReplayService {
  final ApiService _apiService;

  PathReplayService(this._apiService);

  Future<List<Data>> getPathReplay(
    String token,
    Map<String, dynamic> queryParams,
  ) async {
    Dio dio = Dio();

    final response = await dio.get(
      "${ApiUrls.gpsBase}/reports/position",
      queryParameters: queryParams,
      options: Options(headers: {"Authorization": token}),
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseBody = response.data;
        final List<dynamic> data = responseBody['data'];

        return data.map((e) => Data.fromJson(e)).toList();
      } catch (e) {
        throw Exception("Failed to fetch path replay data");
      }
    } else {
      throw Exception("API returned error: ${response.statusMessage}");
    }
  }

  Future<List<TripPath>> getTripPath(String token, int deviceId) async {
    Dio dio = Dio();

    final response = await dio.get(
      "${ApiUrls.gpsBase}/reports/last_trip_position_records",
      queryParameters: {"device_id": deviceId},
      options: Options(headers: {"Authorization": token}),
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseBody = response.data;
        final List<dynamic> data = responseBody['data'];

        return data.map((e) => TripPath.fromJson(e)).toList();
      } catch (e, stackTrace) {
        throw Exception("Failed to fetch trip path data: $e");
      }
    } else {
      throw Exception(
        "Trip Path API returned error: ${response.statusMessage}",
      );
    }
  }
}
