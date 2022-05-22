import 'package:app/screens/payment/payment.dart';
import 'package:app/screens/cart/voucher/body.dart';
import 'package:app/utils/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/components/default_button.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../welcome/auth_bottom_sheet.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  dynamic paymentMethod;

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
                    displayBottomSheet(
                        context, const AuthBottomSheet(child: Voucher()));
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
                const Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\$ " "${500}",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(text: "Check Out", press: () async {}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
