import 'dart:developer';

import 'package:app/models/cart/getcart/cart.dart';
import 'package:app/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/constants/storage.dart';
import '../../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<GetCartResponse> cart;
  late int stock;

  @override
  void initState() {
    super.initState();
    cart = CartItems().getCart();
  }

  @override
  Widget build(BuildContext context) {
    return
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: FutureBuilder<GetCartResponse>(
            future: cart,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.details.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Dismissible(
                        key: Key(snapshot.data!.details[index].id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            deleteCart(
                                snapshot.data!.details[index].productId, null);
                            snapshot.data!.details.removeAt(index);
                          });
                        },
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              SvgPicture.asset("assets/temp/icons/Trash.svg"),
                            ],
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(right: 20.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CartCard(
                                  productResponse: ProductItems()
                                      .getSingleProduct(int.parse(snapshot
                                          .data!.details[index].productId)),
                                  index: index),
                              Center(
                                  child: Container(
                                height: 22,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: const Color(0xFFFDBF30))),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (snapshot.data!.details[index]
                                                      .quantity >
                                                  1) {
                                                snapshot.data!.details[index]
                                                    .quantity--;
                                              }
                                              deleteCart(
                                                  snapshot.data!.details[index]
                                                      .productId,
                                                  1);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.green,
                                            size: 18,
                                          )),
                                      Text(
                                        '${snapshot.data!.details[index].quantity}',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            getStock(snapshot.data!
                                                .details[index].productId);
                                            var stock =
                                                await GlobalStorage.read(
                                                    key: "stock");
                                            setState(() {
                                              if (snapshot.data!.details[index]
                                                      .quantity <
                                                  int.parse(stock!)) {
                                                snapshot.data!.details[index]
                                                    .quantity++;
                                                addCart(
                                                    snapshot
                                                        .data!
                                                        .details[index]
                                                        .productId,
                                                    1);
                                              }
                                            });
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.green,
                                            size: 18,
                                          )),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                        )),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('failed');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        );
  }

  void deleteCart(String id, int? quantity) async {
    try {
      await CartItems().deleteCart(id, quantity);
    } catch (e) {
      log(e.toString());
    }
  }

  void addCart(String id, int? quantity) async {
    try {
      var response = await CartItems().addCart(id, quantity);
    } catch (e) {
      log(e.toString());
    }
  }

  void getStock(String id) async {
    try {
      var response = await CartItems().getStock(id);
    } catch (e) {
      log(e.toString());
    }
  }
}
