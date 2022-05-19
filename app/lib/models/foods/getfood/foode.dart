import 'dart:convert';
import 'dart:developer';
import 'package:app/models/cart/addtocart/cart_request.dart';
import 'package:app/models/cart/addtocart/error.dart';
import 'package:app/models/api/base_response.dart';
import 'package:app/models/temp/Images.dart';
import 'package:app/utils/api_service.dart';

// =================== User related models ===================

GetFoodResponse foodFromJson(String str) =>
    GetFoodResponse.fromJson(json.decode(str));

String userToJson(GetFoodResponse data) => json.encode(data.toJson());

class GetFoodResponse {
  GetFoodResponse(
    this.id,
    this.name,
    this.description,
    this.price,
    this.original_price,
    this.stock,
    this.order_count,
    this.created_at,
    this.updated_at,
      this.images,
  );

  int id;
  String name;
  String description;
  int price;
  int original_price;
  int stock;
  int order_count;
  DateTime created_at;
  DateTime updated_at;
  List<Images> images;

  factory GetFoodResponse.fromJson(Map<String, dynamic> json) =>
      GetFoodResponse(
        json["id"],
        json["name"],
        json["description"],
        json["price"],
        json["original_price"],
        json["stock"],
        json["order_count"],
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["created_at"]),
        json["images"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "original_price": original_price,
        "stock": stock,
        "order_count": order_count,
        "updated_at": updated_at.toIso8601String(),
        "created_at": created_at.toIso8601String(),
      };
}

// =================== Class responsed for api called ===================

class Foode {
  Future<GetFoodResponse> GetFood() async {
    var response = await ApiService().get("/api/products/all");
    if (response.statusCode == 200) {
      var cartResponse =
          GetFoodResponse.fromJson(responseFromJson(response.body).data);
      return cartResponse;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load food');
    }
  }
}
