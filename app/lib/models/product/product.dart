import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

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
      {this.id,
      this.name,
      this.description,
      this.price,
      this.originalPrice,
      this.stock,
      this.categoryId,
      this.images,
      this.createdAt,
      this.updatedAt});

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
    final Map<String, dynamic> data = Map<String, dynamic>();
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

  Future<List<Product>?> loadList() async {
    Uri link = Uri(
        scheme: 'https',
        host: 'food-ordering-app-149311cb.herokuapp.com',
        path: '/api/products/all');
    try {
      final data = await http.get(link);
      final response = json.decode(data.body);

      return ProductsResponse.fromJson(response).product;
    } catch (e) {
      log(e.toString());
    }
    return null;
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
