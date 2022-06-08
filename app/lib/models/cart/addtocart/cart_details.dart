import 'dart:convert';
import 'dart:developer';
import 'dart:core';

class AddCartDetails
{
  String id;
  int quantity;
  String productId;
  DateTime createdAt;
  DateTime updatedAt;
  String cartId;
  AddCartDetails(this.id, this.quantity, this.productId, this.createdAt,this.updatedAt, this.cartId);

  factory AddCartDetails.fromJson(Map<dynamic, dynamic> json) => AddCartDetails(
      json["id"],
      json["quantity"],
      json["product_id"],
      DateTime.parse(json["created_at"]),
      DateTime.parse(json["updated_at"]),
      json["cart_id"]);
}
