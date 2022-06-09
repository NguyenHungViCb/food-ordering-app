import 'dart:convert';

import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/models/cart/getcart/cart.dart';
import 'package:app/screens/cart/voucher/voucher_page.dart';
import 'package:app/screens/payment/payment.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/components/default_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../welcome/auth_bottom_sheet.dart';
import '../../checkout/components/body.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  _CheckoutCardState createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  dynamic paymentMethod;
  late Future<double> sumPrice;
  dynamic vouchers;

  @override
  void initState() {
    super.initState();
    sumPrice = CartItems().sum();
    getTextFromFile();
  }

  getDefaultMethod() async {
    var savedToken = await GlobalStorage.read(key: "tokens");
    if (savedToken != null) {
      var decoded = json.decode(savedToken);
      if (decoded != null && decoded['token'] != null) {
        var defaultMethod = await PaymentService.fetchDefaultMethod();
        if (paymentMethod == null ||
            paymentMethod['id'] != defaultMethod['id']) {
          setState(() {
            paymentMethod = defaultMethod;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getDefaultMethod();
    return FutureBuilder<double>(
        future: sumPrice,
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(15),
              horizontal: getProportionateScreenWidth(30),
            ),
            // height: 174,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -15),
                  blurRadius: 20,
                  color: const Color(0xFFDADADA).withOpacity(0.15),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var savedToken =
                              await GlobalStorage.read(key: "tokens");
                          if (savedToken != null) {
                            var decoded = json.decode(savedToken);
                            if (decoded != null && decoded['token'] != null) {
                              Navigator.pushNamed(context, Payment.routeName)
                                  .then((value) => setState(() {}));
                            }
                          } else {
                            FToast().init(context).showToast(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: const BoxDecoration(
                                      color: Color(0xfffa5252),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/error.svg",
                                        width: 18,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text(
                                        "Please login to add payment method",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                /* backgroundColor: const Color(0xfffa5252), */
                                gravity: ToastGravity.CENTER,
                                toastDuration: const Duration(seconds: 3),
                                positionedToastBuilder: (context, child) {
                                  return Positioned(
                                      child: child, top: 150, left: 80);
                                });
                          }
                        },
                        child: paymentMethod == null
                            ? const Text("Add Payment Method")
                            : Row(
                                children: [
                                  SvgPicture.asset(
                                    paymentMethod['card']["brand"] == 'visa'
                                        ? "assets/images/visa.svg"
                                        : "assets/images/mastercard.svg",
                                    width: 30,
                                  ),
                                  const SizedBox(width: 20),
                                  Text(paymentMethod['card']['last4'])
                                ],
                              ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                child: const Text("Address"),
                                onTap: () async {
                                  String? savedToken =
                                      await GlobalStorage.read(key: "tokens");
                                  if (savedToken != null) {
                                    displayBottomSheet(
                                        context,
                                        const AuthBottomSheet(
                                            child: Checkout()));
                                  } else {
                                    FToast().init(context).showToast(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: const BoxDecoration(
                                              color: Color(0xfffa5252),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/error.svg",
                                                width: 18,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Text(
                                                "Please login to view/update address",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                        /* backgroundColor: const Color(0xfffa5252), */
                                        gravity: ToastGravity.CENTER,
                                        toastDuration:
                                            const Duration(seconds: 3),
                                        positionedToastBuilder:
                                            (context, child) {
                                          return Positioned(
                                              child: child, top: 150, left: 80);
                                        });
                                  }
                                },
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: kTextColor,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                child: Text(vouchers),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, VouchersScreen.routeName);
                                },
                              ),
                              const SizedBox(width: 10),
                              vouchers != "Add voucher code"
                                  ? IconButton(
                                      icon: const Icon(Icons.dangerous),
                                      onPressed: () async {
                                        setState(() async {
                                         await GlobalStorage.delete(key: "code");
                                         await GlobalStorage.delete(key: "id");
                                         await GlobalStorage.delete(key: "discount");
                                         await Navigator.pushNamed(context, CartScreen.routeName);
                                      });
                                    })
                                  : const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: kTextColor,
                                    )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              text: "\$ ${snapshot.data}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(190),
                        child: DefaultButton(
                            text: "Check Out",
                            press: () async {
                              // Replace this hard code id by allow user to select voucher
                              // You can pass null to skip apply voucher
                              var response = await PaymentService.checkout(
                                  context, paymentMethod, "test");
                              if (response["error"] != true) {
                                await GlobalStorage.write(
                                    key: "isCheckouted", value: "true");
                                Navigator.popUntil(
                                    context,
                                    (route) =>
                                        route.settings.name ==
                                        HomePage.routeName);
                              }
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  displayBottomSheet(context, Widget sheet) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: sheet,
            )).then((value) => {});
  }

  Future<String> getVouchers() async {
    var voucherCode = await GlobalStorage.read(key: "code");
    print(voucherCode.toString());
    if (voucherCode.toString() != "null") {
      return voucherCode.toString();
    } else {
        return "Add voucher code";
    }
  }
  void getTextFromFile() async {
    try {
      String data = await getVouchers();
      setState(() {
        vouchers = data;
      });
    } catch (ex) {
      print(ex);
    }
  }
}
