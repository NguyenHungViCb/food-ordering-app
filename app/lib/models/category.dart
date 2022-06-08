import 'package:app/models/product/product.dart';

class Category {
  String id;
  String name;
  List<Images> images;
  String? description;
  String createdAt;
  String updatedAt;
  List<Product> products;

  Category(this.id, this.name, this.images, this.description, this.createdAt,
      this.updatedAt, this.products);

  factory Category.fromJson(Map<dynamic, dynamic> json) => Category(
      json['id'],
      json['name'],
      (json["images"] as List).isNotEmpty
          ? (json['images'] as List).map((e) => Images.fromJson(e)).toList()
          : [],
      json["description"] ?? "",
      json["created_at"],
      json["updated_at"],
      (json["products"] as List).isNotEmpty
          ? (json["products"] as List).map((e) => Product.fromJson(e)).toList()
          : []);
}
