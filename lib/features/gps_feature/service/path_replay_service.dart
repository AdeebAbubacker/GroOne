import 'package:dio/dio.dart';

import '../../../data/network/api_service.dart';
import '../../../data/model/result.dart';
import '../constants/app_constants.dart';
import '../model/path_positions_pojo.dart';

class PathReplayService {
  final ApiService _apiService;



  PathReplayService(this._apiService);

  Future<List<Data>> getPathReplay(String token, Map<String, dynamic> queryParams) async {
    Dio dio = Dio();

    final response = await dio.get(
      "https://api.letsgro.co/api/v1/auth/reports/position",
      queryParameters: queryParams,
      options: Options(
        headers: {
          "Authorization": AppConstants.token,
        },
      ),
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseBody = response.data;
        final List<dynamic> data = responseBody['data'];

        return data.map((e) => Data.fromJson(e)).toList();
      } catch (e) {
        print("Parsing Error: $e");
        throw Exception("Failed to fetch path replay data");
      }
    } else {
      print(response.statusCode);
      print(response.statusMessage);
      throw Exception("API returned error: ${response.statusMessage}");
    }
  }

}
