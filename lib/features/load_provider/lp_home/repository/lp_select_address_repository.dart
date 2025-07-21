import 'package:geolocator/geolocator.dart' as geo;
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/service/location_service.dart';

class LPMapSelectAddressRepository {
  final LocationService _locationService;
  LPMapSelectAddressRepository(this._locationService);

  Future<Result<geo.Position>?> getCurrentLatLongData() async {
    try {
      return await _locationService.getCurrentLatLong();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}