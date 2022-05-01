import 'dart:convert';
import 'dart:developer';
import 'package:app/models/cart/addtocart/cart_request.dart';
import 'package:app/models/cart/addtocart/error.dart';
import 'package:app/models/api/base_response.dart';


import 'package:app/utils/api_service.dart';

import '../addtocart/cart_details.dart';

// =================== User related models ===================

GetCartResponse userFromJson(String str) =>
    GetCartResponse.fromJson(json.decode(str));

String userToJson(GetCartResponse data) => json.encode(data.toJson());

class GetCartResponse {
  GetCartResponse(
      this.id,
      this.userId,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.details,
      );

  int id;
  int userId;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  List<CartDetails> details;

  factory GetCartResponse.fromJson(Map<String, dynamic> json) => GetCartResponse(
    json["id"],
    json["user_id"],
    json["is_active"],
    DateTime.parse(json["updated_at"]),
    DateTime.parse(json["created_at"]),
    json["cart_details"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "is_active": isActive,
    "cart_details": details,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
  };
}

// =================== Class responsed for api called ===================

class CartItems {
  Future<GetCartResponse> GetCart() async {
      var response = await ApiService().get("/api/carts/active");
      if (response.statusCode == 200) {
        var cartResponse = GetCartResponse.fromJson(responseFromJson(response.body).data);
        return cartResponse;}
      else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load cart');
      }
  }
}
