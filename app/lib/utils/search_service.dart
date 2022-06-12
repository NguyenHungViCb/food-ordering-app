import 'package:app/models/api/base_response.dart';
import 'package:app/models/product/product.dart';
import 'package:app/utils/api_service.dart';

class SearchService {
  Future<List<Product>> search(String keyword) async {
    var response =
        await ApiService().get("/api/products/search?keyword=" + keyword);
    return (responseFromJson(response.body).data['rows'] as List)
        .map((e) => Product.fromJson(e))
        .toList();
  }
}
