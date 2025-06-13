import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import '../../../../data/model/result.dart';
import '../../../login/repository/user_information_repository.dart';
import '../service/vp_all_load_service.dart';

class VpLoadRepository {
  final VpLoadService service;
  final UserInformationRepository userRepo;

  VpLoadRepository(this.service, this.userRepo);

  Future<Result<List<VpRecentLoadData>>> fetchLoads({
    required int type,
    String search = "",
    bool forceRefresh = false
  }) async {
    final customerId = await userRepo.getUserID() ?? '';
    return service.fetchLoads(customerId: customerId, type: type, search: search,forceRefresh: forceRefresh);
  }
}
