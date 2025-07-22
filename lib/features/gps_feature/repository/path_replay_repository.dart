import '../model/path_positions_pojo.dart';
import '../model/trip_path_model.dart';
import '../service/path_replay_service.dart';

class PathReplayRepository {
  final PathReplayService _service;

  PathReplayRepository(this._service);

  Future<List<Data>> getPathReplay(
    String token,
    Map<String, dynamic> queryParams,
  ) {
    return _service.getPathReplay(token, queryParams);
  }

  Future<List<TripPath>> getTripPath(String token, int deviceId) {
    return _service.getTripPath(token, deviceId);
  }
}
