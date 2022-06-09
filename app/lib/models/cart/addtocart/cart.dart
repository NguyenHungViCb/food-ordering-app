import 'dart:convert';
import 'package:app/models/cart/addtocart/cart_details.dart';
import 'package:app/models/cart/addtocart/failed_inserts.dart';

// =================== User related models ===================

CartResponse userFromJson(String str) =>
    CartResponse.fromJson(json.decode(str));

class CartResponse {
  CartResponse(this.id, this.userId, this.createdAt, this.updatedAt,
      this.succeededInserts, this.failedInserts);

  String id;
  String? userId;
  DateTime createdAt;
  DateTime updatedAt;
  List<AddCartDetails> succeededInserts;
  List<FailedInserts> failedInserts;
  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        json["id"],
        json["user_id"],
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["created_at"]),
        json["succeeded_inserts"] != null
            ? List<AddCartDetails>.from(json["succeeded_inserts"]
                .map((x) => AddCartDetails.fromJson(x)))
            : [],
        List<FailedInserts>.from(
            json["failed_inserts"].map((x) => FailedInserts.fromJson(x))),
      );
}

// =================== API call in getCart/cart.dart ===================
