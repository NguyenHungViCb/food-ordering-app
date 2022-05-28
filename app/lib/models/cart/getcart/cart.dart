import 'dart:convert';
import 'dart:developer';
import 'package:app/models/api/base_response.dart';
import 'package:app/share/constants/storage.dart';

import 'package:app/utils/api_service.dart';

import '../addtocart/cart_details.dart';

// =================== User related models ===================

GetCartResponse cartFromJson(String str) =>
    GetCartResponse.fromJson(json.decode(str));

String userToJson(GetCartResponse data) => json.encode(data.toJson());

class CartDetails {
  String id;
  int quantity;
  String productId;
  DateTime createdAt;
  DateTime updatedAt;
  String cartId;

  CartDetails(this.id, this.quantity, this.productId, this.createdAt,
      this.updatedAt, this.cartId);

  factory CartDetails.fromJson(Map<String, dynamic> json) => CartDetails(
      json["id"],
      json["quantity"],
      json["product_id"],
      DateTime.parse(json["created_at"]),
      DateTime.parse(json["updated_at"]),
      json["cart_id"]);
}

class GetCartResponse {
  GetCartResponse(
    this.id,
    this.userId,
    /* this.isActive, */
    this.createdAt,
    this.updatedAt,
    this.details,
  );

  String id;
  String userId;
  /* bool isActive; */
  DateTime createdAt;
  DateTime updatedAt;
  List<CartDetails> details;

  factory GetCartResponse.fromJson(Map<dynamic, dynamic> json) =>
      GetCartResponse(
        json["id"],
        json["user_id"],
        /* json["is_active"], */
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["created_at"]),
        List<CartDetails>.from(
            json["cart_details"].map((x) => CartDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": id,
        "quantity": userId,
      };
}

class ItemsBody {
  String productId;
  int? quantity;

  ItemsBody({required this.productId, this.quantity});

  Map<String, dynamic> toJson() =>
      {"product_id": productId, "quantity": quantity};
}

class RemoveCartRequest {
  List<ItemsBody> items;

  RemoveCartRequest({required this.items});

  Map<String, dynamic> toJson() => {
        "items": items,
      };
}

int Sum = 0;
// =================== Class responsed for api called ===================

class CartItems {
  Future<GetCartResponse> GetCart() async {
    var response = await ApiService().get("/api/carts/active");
    print(responseFromJson(response.body).data);
    if (response.statusCode == 200) {
      //var cartDetails = GetCartItems();
      var cartResponse =
          GetCartResponse.fromJson(responseFromJson(response.body).data);
      GlobalStorage.write(key: "cart_id", value: cartResponse.id);
      return cartResponse;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load cart');
    }
  }

  Future<dynamic> DeleteCart(String productId, int? quantity) async {
    try {
      await ApiService().post(
          "/api/carts/items/remove",
          json.encode({
            "items": [
              {"product_id": productId, "quantity": quantity}
            ]
          }));
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<dynamic> AddCart(String productId, int? quantity) async {
    try {
      await ApiService().post(
          "/api/carts/items/add",
          json.encode({
            "items": [
              {"product_id": productId, "quantity": quantity}
            ]
          }));
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
