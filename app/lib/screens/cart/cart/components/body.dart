import 'dart:developer';

import 'package:app/models/cart/getcart/cart.dart';
import 'package:app/models/product/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
  var total;
}

class _BodyState extends State<Body> {
  var total;
  late Future<GetProductResponse> product;
  late Future<GetCartResponse> cart;

  @override
  void initState() {
    super.initState();
    cart = CartItems().GetCart();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: FutureBuilder<GetCartResponse>(
        future: cart,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.details.length,
              itemBuilder: (context, index) =>
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child:
                    Dismissible(
                        key: Key(snapshot.data!.details[index].id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            DeleteCart(snapshot.data!.details[index].productId,null);
                            snapshot.data!.details.removeAt(index);
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
                          padding: EdgeInsets.only(right: 20.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CartCard(productResponse: ProductItems()
                                  .getSingleProduct(int.parse(
                                  snapshot.data!.details[index].productId)),
                                  index: index),
                              //items(context),
                              //SizedBox(width: 100),
                              Center(
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Color(0xFFFDBF30))
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: <Widget>[
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  snapshot.data!.details[index].quantity--;
                                                });
                                              }
                                              ,
                                              child: Icon(Icons.remove,
                                                color: Colors.green,
                                                size: 18,)),
                                          Text(
                                            '${snapshot.data!.details[index].quantity}',
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  snapshot.data!.details[index].quantity++;
                                                });
                                              }
                                              ,
                                              child: Icon(
                                                Icons.add, color: Colors.green,
                                                size: 18,)),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        )

                    ),
                  ),
            );
          } else if (snapshot.hasError) {
            return Text('failed');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),

    );
  }

  void DeleteCart(String Id, int? quantity) async {
    try{
      await Future.delayed(const Duration(seconds: 1));

      await CartItems().DeleteCart(Id, quantity);
    }
    catch(e){
      log(e.toString());
    }
  }
  void sum()
  {

  }
}