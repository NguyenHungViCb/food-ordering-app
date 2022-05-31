import 'package:app/models/product/product.dart';
import 'package:app/screens/detail/widget/food_quantity.dart';
import 'package:app/share/constants/colors.dart';
import 'package:flutter/material.dart';

class FoodDetail extends StatelessWidget {
  final Product food;
  final int? counter;
  final Function()? onTapAdd;
  final Function()? onTapMinus;
  final Function()? onTapAddCart;

  const FoodDetail(this.food,
      {this.counter, this.onTapAdd, this.onTapMinus, this.onTapAddCart});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      color: kBackground,
      child: Column(
        children: [
          Text(
            food.name ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconText(
                Icons.access_time_outlined,
                Colors.blue,
                '30.0',
              ),
              _buildIconText(Icons.star_outlined, Colors.amber, '50.0'),
              // _buildIconText(
              //     Icons.local_fire_department_outlined,
              //     Colors.red,
              //     food.cal
              // )
            ],
          ),
          SizedBox(height: 30),
          FoodQuantity(
            food,
            onTapMinus: onTapMinus,
            onTapAdd: onTapAdd,
            counter: counter,
            onTapAddCart: onTapAddCart,
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Text(
                'Suggestions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: food.images?.length ?? 0,
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      food.images?[index].src ?? '',
                      width: 50,
                    ),
                    Text(
                      food.name?[index] ?? '',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ), //food.ingredients.length
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Text(
                'About',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            food.description ?? '',
            style: TextStyle(
              wordSpacing: 1.2,
              height: 1.5,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }
}
