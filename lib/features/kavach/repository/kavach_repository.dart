import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/kavach_product.dart';

class KavachRepository {
  final http.Client client;

  KavachRepository({required this.client});

  Future<List<KavachProduct>> fetchProducts({String search = ""}) async {
    final response = await client.get(Uri.parse(
      "http://gro-devapi.letsgro.co/fleet/api/v1/product/list?fleetProductId=2&page=1&limit=10&search=$search",
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rows = data['data']['rows'] as List;
      return rows.map((e) => KavachProduct.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
