import 'package:geolocator/geolocator.dart' as geo;
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/service/location_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LPMapSelectAddressRepository {
  final LocationService _locationService;
  LPMapSelectAddressRepository(this._locationService);

  Future<Result<geo.Position>?> getCurrentLatLongData() async {
    try {
      return await _locationService.getCurrentLatLong();
    } catch (e) {
      CustomLog.error(this, "Failed to get current lat & long data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}