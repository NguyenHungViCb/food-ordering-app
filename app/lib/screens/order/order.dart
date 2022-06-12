import 'package:app/constants.dart';
import 'package:app/screens/order/item.dart';
import 'package:app/share/buttons/danger_button.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/models/order/orders.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/order_service.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/screens/home/home.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late ResponseOrder order = OrderService().nullSafety;
  late OrderSocket socket = OrderSocket();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  fetchOrder() async {
    if (order.id == "0") {
      var _order = await OrderService().fetchOnGoingOrder();
      setState(() {
        order = _order;
      });
    }
  }

  initialize() async {
    // await socket.cancel();
    await socket.connect();
    socket.onStatusUpdate((data) async {
      ResponseOrder _order = await OrderService().fetchOnGoingOrder();
      if (_order.id == "0") {
        if (data == 'canceled') {
          FToast().init(context).showToast(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(
                    color: Color(0xfffa5252),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                      "Order has been canceled. A refund will be transfer to your account soon",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              /* backgroundColor: const Color(0xfffa5252), */
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 3),
              positionedToastBuilder: (context, child) {
                return Positioned(child: child, top: 150, left: 80);
              });
          Navigator.popUntil(
              context, (route) => route.settings.name == HomePage.routeName);
        } else {
          FToast().init(context).showToast(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(
                    color: Color(0xfffa5252),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                      "Order has complete",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              /* backgroundColor: const Color(0xfffa5252), */
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 3),
              positionedToastBuilder: (context, child) {
                return Positioned(child: child, top: 150, left: 80);
              });
          Navigator.popUntil(
              context, (route) => route.settings.name == HomePage.routeName);
        }
      }
      setState(() {
        order = _order;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchOrder();
    Map<String, double?> status = OrderProgressService().getStatus(order);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          child: CustomAppBar(Icons.arrow_back_ios_new_rounded, null,
              leftCallback: (context) {
            Navigator.pop(context);
          }),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 3))
          ]),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: const BoxDecoration(
          color: kBackground,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("We are preparing your order",
                          style: TextStyle(
                              color: Color(0xFF495057),
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      SvgPicture.asset(
                        'assets/images/food.svg',
                        width: 64,
                        height: 64,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SvgPicture.asset(
                      'assets/images/money.svg',
                      width: 24,
                      height: 24,
                    ),
                    Expanded(
                        child: LinearProgressIndicator(
                      value: status['confirmed'],
                    )),
                    SvgPicture.asset(
                      'assets/images/pot.svg',
                      width: 24,
                      height: 24,
                    ),
                    Expanded(
                        child: LinearProgressIndicator(
                      value: status['processing'],
                    )),
                    SvgPicture.asset(
                      'assets/images/bike.svg',
                      width: 24,
                      height: 24,
                    ),
                    Expanded(
                        child:
                            LinearProgressIndicator(value: status['shipping'])),
                    SvgPicture.asset(
                      'assets/images/home.svg',
                      width: 20,
                      height: 20,
                    ),
                  ]),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(
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
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  order.id != "0" && order.details.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: order.details.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: const EdgeInsets.only(right: 20.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OrderItemCard(item: order.details[index]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
            order.allowCancel
                ? Column(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 100,
                          child: DangerousButton(
                              onPressed: (context) async {
                                var result = await OrderService().cancelOrder();
                                if (result == null) {
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
                                              "An error has occured",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                } else {
                                  await GlobalStorage.write(
                                      key: "isCheckouted", value: "true");
                                  FToast().init(context).showToast(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: const BoxDecoration(
                                            color: Color(0xff37b24d),
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
                                              "Canceled order successful",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                  Navigator.popUntil(
                                      context,
                                      (route) =>
                                          route.settings.name ==
                                          HomePage.routeName);
                                }
                              },
                              text: "Cancel"))
                    ],
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
