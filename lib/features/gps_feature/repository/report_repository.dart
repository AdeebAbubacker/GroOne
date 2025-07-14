import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../model/report_model.dart';
import '../service/report_service.dart';

class GpsReportRepository {
  final GpsReportService _service;

  GpsReportRepository(this._service);


  Future<Result<List<Report>>> fetchReports({
    String? fromDate,
    String? toDate,
    int? vehicleId,
  }) async {
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate API delay

      return Success([
        {
          "date": "Jul 10, 2025",
          "safetyCount": 8,
          "colorCode": "green",
          "locations": [
            {
              "address":
              "Coca Cola Bottling Plant, Nemam Main road, Uthrekhand, Porur, Dubai Main road, Chennai -60056",
              "time": "09:15 AM",
              "isSafe": true
            },
            {
              "address":
              "PepsiCo Factory, Mount Road, Nandanam, Chennai -60035",
              "time": "01:30 PM",
              "isSafe": false
            }
          ],
          "distance": 48250,
          "avgSpeed": 55,
          "engineOn": "6h 20m",
          "idleTime": "1h 05m"
        },
        {
          "date": "Jul 09, 2025",
          "safetyCount": 10,
          "colorCode": "red",
          "locations": [
            {
              "address":
              "HPCL Depot, GST Road, Guindy, Chennai -60032",
              "time": "10:45 AM",
              "isSafe": false
            }
          ],
          "distance": 75230,
          "avgSpeed": 65,
          "engineOn": "7h 15m",
          "idleTime": "45m"
        }
      ].map((e) => Report.fromJson(e)).toList());
    } catch (e) {
      CustomLog.error(this, "Mocked fetchReports failed", e);
      return Error(DeserializationError());
    }
  }




// Future<Result<List<Report>>> fetchReports({
  //   String? fromDate,
  //   String? toDate,
  //   int? vehicleId,
  // }) async {
  //   try {
  //     return await _service.fetchReports(
  //       fromDate: fromDate,
  //       toDate: toDate,
  //       vehicleId: vehicleId,
  //     );
  //   } catch (e) {
  //     CustomLog.error(this, "Failed to fetch reports in repository", e);
  //     return Error(ErrorWithMessage(message: e.toString()));
  //   }
  // }
}
