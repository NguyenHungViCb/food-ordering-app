import 'package:app/models/cart/addtocart/cart.dart';
import 'package:app/models/cart/addtocart/cart_request.dart';
import 'package:app/models/product/product.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/detail/widget/food_detail.dart';
import 'package:app/screens/detail/widget/food_img.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Product food;

  DetailPage(this.food);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int counter = 0;

  void _counter({bool tick = false}) {
    setState(() {
      if (tick) {
        counter -= 1;
      } else {
        counter += 1;
      }
      if (counter < 0) counter = 0;
    });
  }

  void _onTapAddCart() {
    if (widget.food.id != null) {
      final item =
          CartRequest(productId: int.parse(widget.food.id!), quantity: counter);
      Cart().AddtoCart(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(Icons.arrow_back_ios_outlined, Icons.favorite_outline,
                leftCallback: () => Navigator.of(context).pop()),
            FoodImg(widget.food),
            FoodDetail(
              widget.food,
              counter: counter,
              onTapAdd: _counter,
              onTapMinus: () => _counter(tick: true),
              onTapAddCart: _onTapAddCart,
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 56,
        child: RawMaterialButton(
          fillColor: kPrimaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
                size: 30,
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  counter.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, CartScreen.routeName);
          },
        ),
      ),
    );
  }
}
