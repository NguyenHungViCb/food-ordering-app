import 'dart:convert';
import 'dart:developer';
import 'dart:core';

class CartDetails
{
  int id;
  int quantity;
  int productId;
  DateTime createdAt;
  DateTime updatedAt;

  CartDetails(this.id, this.quantity, this.productId, this.createdAt,this.updatedAt);

  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
    "product_id":productId,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
  };
}
