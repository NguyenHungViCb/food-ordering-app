import 'package:app/models/cart/getcart/cart.dart';
import 'package:app/screens/cart/voucher/voucher_page.dart';
import 'package:app/screens/payment/payment.dart';
import 'package:app/utils/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/components/default_button.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';

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

  @override
  void initState() {
    super.initState();
    sumPrice = CartItems().sum();
  }
  getDefaultMethod() async {
    var defaultMethod = await PaymentService.fetchDefaultMethod();
    if (paymentMethod == null || paymentMethod['id'] != defaultMethod['id']) {
      setState(() {
        paymentMethod = defaultMethod;
      });
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
                        onTap: () {
                          Navigator.pushNamed(context, Payment.routeName)
                              .then((value) => setState(() {}));
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
                      InkWell(
                        child: const Text("Add voucher code"),
                        onTap: () {
                          // displayBottomSheet(
                          //     context, const AuthBottomSheet(child: Voucher()));
                          Navigator.pushNamed(context, VouchersScreen.routeName);
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
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              text:  "\$ ${snapshot.data}",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(190),
                        child: DefaultButton(
                            text: "Check Out",
                            press: () async {
                              PaymentService.checkout(paymentMethod, "test");
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
