import 'dart:convert';
import 'dart:developer';
import 'package:app/models/cart/addtocart/cart_request.dart';
import 'package:app/models/cart/addtocart/error.dart';
import 'package:app/models/api/base_response.dart';
import 'package:app/models/cart/addtocart/failed_inserts.dart';
import 'package:app/models/tokens/tokens.dart';
import 'package:app/models/users/auth.dart';
import 'package:app/utils/api_service.dart';

import 'package:app/models/cart/addtocart/cart_details.dart';

import 'package:app/models/cart/addtocart/succeeded_inserts.dart';

// =================== User related models ===================

CartResponse userFromJson(String str) =>
    CartResponse.fromJson(json.decode(str));

String userToJson(CartResponse data) => json.encode(data.toJson());

class CartResponse {
  CartResponse(
      this.id,
      this.userId,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.details,
      this.succeededInserts,
      this.failedInserts,
      this.error
      );

  int id;
  int userId;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  CartDetails details;
  SucceededInserts succeededInserts;
  FailedInserts failedInserts;
  Error error;

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
    json["id"],
    json["user_id"],
    json["is_active"],
    DateTime.parse(json["updated_at"]),
    DateTime.parse(json["created_at"]),
    json["details"],
    json["succeeded_inserts"],
    json["failed_inserts"],
    json["error"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "is_active": isActive,
    "details": details,
    "succeeded_inserts": succeededInserts,
    "failed_inserts": failedInserts,
    "error": error,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
  };
}

// =================== Class responsed for api called ===================

class Cart {
  Future<dynamic> AddtoCart(CartRequest request) async {
    try {
      var response = await ApiService()
          .post("/api/carts/items/add", json.encode(request.toJson()));
      if (response.statusCode == 200) {
        var cartResponse = CartResponse.fromJson(responseFromJson(response.body).data);
        return cartResponse;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<dynamic> GetCart(CartRequest request) async {
    try {
      var response = await ApiService()
          .get("/api/carts/active");
      if (response.statusCode == 200) {
        var cartResponse = CartResponse.fromJson(responseFromJson(response.body).data);
        return cartResponse;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
