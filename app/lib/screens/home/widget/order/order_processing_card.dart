import 'package:app/models/order/orders.dart';
import 'package:app/share/order/OrderProgress.dart';
import 'package:app/size_config.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class OrderProgressCard extends StatefulWidget {
  final ResponseOrder order;
  final Function updateOrder;
  const OrderProgressCard(
      {Key? key, required this.order, required this.updateOrder})
      : super(key: key);

  @override
  State<OrderProgressCard> createState() => _OrderProgressCardState();
}

class _OrderProgressCardState extends State<OrderProgressCard> {
  /* OrderService orderService = OrderService(); */
  /* late OrderSocket socket; */

  /* @override */
  /* void initState() { */
  /*   super.initState(); */
  /*   if (widget.order.id != "0") { */
  /*     initialize(); */
  /*   } */
  /* } */

  /* initialize() async { */
  /*   socket = await OrderSocket().connect(); */
  /*   socket.onStatusUpdate((data) async { */
  /*     var order = await orderService.fetchOnGoingOrder(); */
  /*     widget.updateOrder(context, order); */
  /*   }); */
  /* } */

  @override
  Widget build(BuildContext context) {
    /* var status = OrderProgressService().getStatus(widget.order); */
    if (widget.order.id == "0") {
      return const SizedBox.shrink();
    }
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(15),
          horizontal: getProportionateScreenWidth(30),
        ),
        width: MediaQuery.of(context).size.width * 100,
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Your order is being prepared.",
                            style: TextStyle(
                                color: Color(0xFF495057),
                                fontWeight: FontWeight.w600)),
                        Text(
                          "Total items: " +
                              widget.order.details.length.toString(),
                          style: const TextStyle(color: Color(0xFF495057)),
                        ),
                        Text(
                          "Total: \$" +
                              widget.order.total.toString(),
                          style: const TextStyle(color: Color(0xFF495057)),
                        )
                      ]),
                  SvgPicture.asset(
                    'assets/images/food.svg',
                    width: 64,
                    height: 64,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              OrderProgress(
                  order: widget.order, updateOrder: widget.updateOrder)
              /* Row(mainAxisAlignment: MainAxisAlignment.center, children: [ */
              /*   SvgPicture.asset( */
              /*     'assets/images/money.svg', */
              /*     width: 24, */
              /*     height: 24, */
              /*   ), */
              /*   Expanded( */
              /*       child: LinearProgressIndicator( */
              /*     value: status['confirmed'], */
              /*   )), */
              /*   SvgPicture.asset( */
              /*     'assets/images/cooking.svg', */
              /*     width: 24, */
              /*     height: 24, */
              /*   ), */
              /*   Expanded( */
              /*       child: LinearProgressIndicator( */
              /*     value: status['processing'], */
              /*   )), */
              /*   SvgPicture.asset( */
              /*     'assets/images/bike.svg', */
              /*     width: 24, */
              /*     height: 24, */
              /*   ), */
              /*   Expanded( */
              /*       child: LinearProgressIndicator(value: status['shipping'])), */
              /*   SvgPicture.asset( */
              /*     'assets/images/home.svg', */
              /*     width: 20, */
              /*     height: 20, */
              /*   ), */
              /* ]) */
            ],
          ),
        ));
  }
}
