import 'package:app/models/temp/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/models/temp/Cart.dart';

import '../../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
  var total;
}

class _BodyState extends State<Body> {
  var total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: demoCart.details.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(demoCart.details[index].id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                demoCart.details.removeAt(index);
              });
            },

            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),

                  SvgPicture.asset("assets/temp/icons/Trash.svg"),
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  CartCard(cart: demoCart, index: index ),
                  SizedBox(width: 100),
                  Center(
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Color(0xFFFDBF30))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                                onTap: (){
                                  setState(() {
                                    demoCart.details[index].stock--;
                                  });
                                }
                                ,child: Icon(Icons.remove,color: Colors.green,size: 18,)),
                            Text('${demoCart.details[index].stock}',style: TextStyle(
                                color: Colors.black
                            ),
                            ),
                            InkWell(
                                onTap: (){
                                  setState(() {
                                    demoCart.details[index].stock++;
                                  });
                                }
                                ,child: Icon(Icons.add,color: Colors.green,size: 18,)),

                          ],
                        ),

                      )
                  ) ,
                ],
              ) ,
            )

          ),
        ),
      ),
    );
  }
}
