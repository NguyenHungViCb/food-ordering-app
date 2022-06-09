import 'package:app/models/api/base_response.dart';
import 'package:app/utils/api_service.dart';

class CartService {
  Future<int> count(String productId, [String? cartId]) async {
    var response = await ApiService().get('/api/carts/items/count?product_id=' +
        productId +
        (cartId != null ? '&cart_id=' + cartId : ''));
    if (response.statusCode == 200) {
      var data = responseFromJson(response.body).data;
      return data;
    }
    return 0;
  }
}
