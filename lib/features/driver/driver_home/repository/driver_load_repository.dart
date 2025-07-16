import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/driver/driver_home/service/driver_load_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import '../../../../data/model/result.dart';
import '../../../login/repository/user_information_repository.dart';

class DriverLoadRepository {
  final DriverLoadService service;
  final UserInformationRepository userRepo;

  DriverLoadRepository(this.service, this.userRepo);

  Future<Result<List<DriverLoadDetails>>> fetchDriverLoads({
    int?loadStatus,
    String search = "",
    bool forceRefresh = false
  }) async {
    final customerId = await userRepo.getUserID() ?? '';
    return service.fetchDriverLoads(driverId: customerId,loadStatus: loadStatus , search: search,forceRefresh: forceRefresh);
  }
}
