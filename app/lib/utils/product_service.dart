import 'dart:convert';
import 'dart:developer';

import 'package:app/models/product/product.dart';
import 'package:app/utils/api_service.dart';

class ProductService {
  final Product _nullSafety = Product("0", "", "", "", "", 0, "0", [], "0", "");
  get nullSafety {
    return _nullSafety;
  }

  Future<List<Product>?> loadList() async {
    try {
      var response = await ApiService().get("/api/products/all");
      final data = json.decode(response.body);

      return ProductsResponse.fromJson(data).product;
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load product');
    }
  }
}
