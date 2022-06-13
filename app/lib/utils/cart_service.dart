import 'dart:developer';

import 'package:app/models/api/base_response.dart';
import 'package:app/models/cart/getcart/cart.dart';
import 'package:app/share/constants/storage.dart';
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

  Future<int> countItemInCart() async
  {
    var cartId = await GlobalStorage.read(key: "cart_id");
    try{
      var response = await ApiService().get("/api/carts/active?cart_id=$cartId");
      print(responseFromJson(response.body).data);
      if (response.statusCode == 200) {
        var cartResponse =
        GetCartResponse.fromJson(responseFromJson(response.body).data);
        return cartResponse.details.length;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return 0;
      }
    }
    catch (e){
      log(e.toString());
      return 0;
    }

  }
}
