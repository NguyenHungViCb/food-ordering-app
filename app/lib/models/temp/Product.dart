import 'dart:developer';

import 'package:app/models/temp/Images.dart';

class Product {
  int id;
  String name, description;
  List<Images> images;
  double originalPrice, price, stock, orderCount;

  Product(
    this.id,
    this.images,
    this.originalPrice,
    this.stock,
    this.orderCount,
    this.name,
    this.price,
    this.description,
  );
}

// Our demo Products
List<Images> demoImages1 =[
  Images(1, "assets/temp/images/dish1.png", "type", DateTime.now(), DateTime.now()),
];
List<Images> demoImages2 =[
  Images(2, "assets/temp/images/dish2.png", "type", DateTime.now(), DateTime.now()),
];
List<Images> demoImages3 =[
  Images(3, "assets/temp/images/dish3.png", "type", DateTime.now(), DateTime.now())
];
List<Product> demoProducts = [
  Product(1, demoImages1, 15.0, 1, 2, "Soba soup",25.0,"des1"),
  Product(2, demoImages2, 15.0, 1, 2, "Tokbokki   ",30.0,"des2"),
  Product(3, demoImages3, 15.0, 1, 2, "Fried rice   ",45.0,"des3"),
];

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
