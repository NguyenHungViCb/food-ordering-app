import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/models/order/orders.dart';
import 'package:app/screens/order/item.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/utils/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderDetail extends StatefulWidget {
  static const routeName = "/order-detail";
  const OrderDetail({Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  ResponseOrder order = OrderService().nullSafety;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String orderId = ModalRoute.of(context)!.settings.arguments as String;
      ResponseOrder _order = await OrderService().fetchOrderById(orderId);
      if (_order.id != "0") {
        setState(() {
          order = _order;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order detail"),
        backgroundColor: const Color(0xFFFDBF30),
        foregroundColor: Colors.black,
      ),
      backgroundColor: kBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Subtotal",
                        // style: TextStyle(
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: 16,
                        //     color: Color(0xFF495057)
                        //     ),
                      ),
                      Row(children: [
                        // order.paymentMethod == "visa"
                        //     ? SvgPicture.asset(
                        //         'assets/images/visa.svg',
                        //         width: 34,
                        //       )
                        //     : order.paymentMethod == "mastercard"
                        //         ? SvgPicture.asset(
                        //             'assets/images/mastercard.svg',
                        //             width: 34,
                        //           )
                        //         : SvgPicture.asset(
                        //             'assets/images/paypal.svg',
                        //             width: 34,
                        //           ),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        Text.rich(
                          TextSpan(
                            text: "\$${order.originalTotal.toString()}",
                            // style: const TextStyle(
                            //     fontWeight: FontWeight.w600,
                            //     color: kPrimaryColor2),
                          ),
                        ),
                      ])
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  order.voucher != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              const Text("Voucher"),
                              Row(
                                children: [
                                  Text(order.voucher!.code),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text("•"),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      "-\$${dp(order.originalTotal - order.total, 2)}")
                                ],
                              )
                            ])
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF495057)),
                      ),
                      Row(children: [
                        order.paymentMethod == "visa"
                            ? SvgPicture.asset(
                                'assets/images/visa.svg',
                                width: 34,
                              )
                            : order.paymentMethod == "mastercard"
                                ? SvgPicture.asset(
                                    'assets/images/mastercard.svg',
                                    width: 34,
                                  )
                                : SvgPicture.asset(
                                    'assets/images/paypal.svg',
                                    width: 34,
                                  ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            text: "\$${order.total.toString()}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor2),
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) =>
                      OrderItemCard(item: order.details[index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemCount: order.details.length),
            )
          ],
        ),
      ),
    );
  }
}

double dp(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}
