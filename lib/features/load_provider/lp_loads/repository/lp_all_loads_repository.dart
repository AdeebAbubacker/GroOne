import 'package:gro_one_app/features/load_provider/lp_loads/service/lp_all_loads_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';

class  LpLoadRepository {
  final LpLoadService service;
  final UserInformationRepository userRepo;

  LpLoadRepository(this.service, this.userRepo);

}
