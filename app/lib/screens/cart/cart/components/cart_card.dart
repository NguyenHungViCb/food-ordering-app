import 'package:app/constants.dart';
import 'package:app/models/temp/Cart.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
    required this.index
  }) : super(key: key);

  final Cart cart;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child:  Row(
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(cart.details[index].images[0].src, fit: BoxFit.fitHeight),
              ),
            ),

          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.details[index].name,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              SizedBox(height: 10),

              Text.rich(
                TextSpan(
                  text: "\$${cart.details[index].price}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  // children: [
                  //   TextSpan(
                  //       text: " x${cart.details[0].stock}",
                  //       style: Theme.of(context).textTheme.bodyText1),
                  // ],
                ),
              )
            ],
          )
        ],
      ),
    );

  }
}
