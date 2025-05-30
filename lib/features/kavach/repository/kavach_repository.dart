import 'dart:convert';
import 'package:gro_one_app/features/kavach/service/kavach_service.dart';
import 'package:http/http.dart' as http;
import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../../login/model/login_model.dart';
import '../model/kavach_product.dart';

class KavachRepository {
  final KavachService _service;

  KavachRepository(this._service);

  Future<Result<List<KavachProduct>>> fetchProducts({String search = "", int page = 1}) {
    return _service.fetchProducts(search: search, page: page);
  }
}

