import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/features/kavach/model/kavach_product.dart';
import '../../../utils/custom_log.dart';

class KavachService {
  final ApiService _apiService;

  KavachService(this._apiService);

  // Future<Result<List<KavachProduct>>> fetchProducts({String search = ""}) async {
  //   try {
  //     final response = await _apiService.get('http://gro-devapi.letsgro.co/fleet/api/v1/product/list?fleetProductId=2&page=1&limit=10&search=$search');
  //
  //     if (response is Success) {
  //       final data = response.value;
  //       final rows = data['data']['rows'] as List;
  //       final products = rows.map((e) => KavachProduct.fromJson(e)).toList();
  //       return Success(products);
  //     } else if (response is Error) {
  //       return Error(response.type);
  //     } else {
  //       return Error(GenericError());
  //     }
  //   } catch (e) {
  //     CustomLog.error(this, "Failed to fetch Kavach products", e);
  //     return Error(DeserializationError());
  //   }
  // }
  Future<Result<List<KavachProduct>>> fetchProducts({String search = "", int page = 1}) async {
    try {
      final response = await _apiService.get(
        'http://gro-devapi.letsgro.co/fleet/api/v1/product/list?fleetProductId=2&page=$page&limit=10&search=$search',
      );

      if (response is Success) {
        final data = response.value;
        final rows = data['data']['rows'] as List;
        final products = rows.map((e) => KavachProduct.fromJson(e)).toList();
        return Success(products);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch Kavach products", e);
      return Error(DeserializationError());
    }
  }

}

