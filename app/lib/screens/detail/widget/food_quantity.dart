import 'package:app/models/product/product.dart';
import 'package:app/share/constants/colors.dart';
import 'package:flutter/material.dart';

class FoodQuantity extends StatelessWidget {
  final Product food;
  final int? counter;
  final Function()? onTapAdd;
  final Function()? onTapMinus;
  final Function()? onTapAddCart;

  const FoodQuantity(this.food,
      {this.counter, this.onTapAdd, this.onTapMinus, this.onTapAddCart});

  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 40,
      child: Stack(children: [
        Align(
          alignment: Alignment(-0.3, 0),
          child: Container(
            width: 120,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                SizedBox(width: 15),
                Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  food.price.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.3, 0),
          child: Container(
            height: double.maxFinite,
            width: 120,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onTapMinus,
                  child: Text(
                    '-',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Text(
                    counter.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: onTapAdd,
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.8, 0),
          child: IconButton(
            onPressed: onTapAddCart,
            icon: Icon(
              Icons.add_shopping_cart,
              color: Colors.amber,
              size: 30.0,
            ),
          ),
        ),
      ]),
    );
  }
}
