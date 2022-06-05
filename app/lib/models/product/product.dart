import 'dart:convert';

import 'package:app/utils/api_service.dart';

GetSingleProductResponse productFromJson(String str) =>
    GetSingleProductResponse.fromJson(json.decode(str));

class GetSingleProductResponse {
  String id, price;
  String? name, description;
  List<Images> images;
  String originalPrice;
  int stock;
  String createdAt, updatedAt;
  String categoryId;

  GetSingleProductResponse(
      this.id,
      this.name,
      this.description,
      this.price,
      this.originalPrice,
      this.stock,
      this.createdAt,
      this.updatedAt,
      this.images,
      this.categoryId);

  factory GetSingleProductResponse.fromJson(Map<dynamic, dynamic> json) =>
      GetSingleProductResponse(
          json["id"],
          json["name"],
          json["description"] ?? '',
          json["price"],
          json["original_price"],
          json["stock"],
          json["created_at"],
          json["updated_at"],
          List<Images>.from(json["images"].map((x) => Images.fromJson(x))),
          json['category_id']);
}

class ProductItems {
  Future<GetSingleProductResponse> getSingleProduct(int id) async {
    var response = await ApiService().get("/api/products/$id");
    final Map parsed = json.decode(response.body);
    if (response.statusCode == 200) {
      var productResponse = GetSingleProductResponse.fromJson(parsed);
      return productResponse;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load product');
    }
  }
}

class Product {
  String? id;
  String? name;
  String? description;
  String? price;
  String? originalPrice;
  int? stock;
  String? categoryId;
  List<Images>? images;
  String? createdAt;
  String? updatedAt;

  Product(
    this.id,
    this.name,
    this.description,
    this.price,
    this.originalPrice,
    this.stock,
    this.categoryId,
    this.images,
    this.createdAt,
    this.updatedAt);

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    originalPrice = json['original_price'];
    stock = json['stock'];
    categoryId = json['category_id'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['original_price'] = originalPrice;
    data['stock'] = stock;
    data['category_id'] = categoryId;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

}

class Images {
  String? src;

  Images({this.src});

  Images.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['src'] = src;
    return data;
  }
}

class ProductsResponse {
  final List<Product>? product;

  ProductsResponse(this.product);

  ProductsResponse.fromJson(Map<String, dynamic>? json)
      : product = (json?['data']?["rows"] as List?)
            ?.map((i) => Product.fromJson(i))
            .toList();
}
