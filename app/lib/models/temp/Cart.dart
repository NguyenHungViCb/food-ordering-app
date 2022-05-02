import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Product.dart';

class Cart {
  int id, userId;
  bool isActive;
  DateTime createdAt, updatedAt;
  List<Product> details;
  Cart(this.id, this.userId, this.isActive, this.createdAt, this.updatedAt, this.details);
}

// Demo data for our cart
var demoCart = Cart(1,3,true,DateTime.now(),DateTime.now(),demoProducts);
// List<Cart> demoCarts = [
//   Cart(product: demoProducts[0], numOfItem: 2),
//   Cart(product: demoProducts[1], numOfItem: 1),
//   Cart(product: demoProducts[3], numOfItem: 1),
// ];
num Sum()
{
  num sum=0;
  for(int i =0;i<demoCart.details.length;i++)
    {
      sum = sum + (demoCart.details[i].price*demoCart.details[i].stock);
    }

  return sum;
}
