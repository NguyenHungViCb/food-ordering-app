import 'package:app/models/order/orders.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/utils/order_service.dart';
import 'package:flutter/material.dart';

class OrderProgress extends StatefulWidget {
  final ResponseOrder order;
  final Function updateOrder;
  const OrderProgress(
      {Key? key, required this.order, required this.updateOrder})
      : super(key: key);

  @override
  State<OrderProgress> createState() => _OrderProgressState();
}

class _OrderProgressState extends State<OrderProgress> {
  OrderService orderService = OrderService();
  late OrderSocket socket = OrderSocket();
  @override
  void initState() {
    super.initState();
    if (widget.order.id != "0") {
      initialize();
    }
  }

  initialize() async {
    await socket.cancel();
    await socket.connect();
    socket.onConnect(() {
      print("connected");
    });
    socket.onStatusUpdate((data) async {
      var order = await orderService.fetchOnGoingOrder();
      if (order['status'] == "canceled") {
        widget.updateOrder(context, OrderService().nullSafety);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var status = OrderProgressService().getStatus(widget.order);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        'assets/images/cooking.svg',
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
      Expanded(child: LinearProgressIndicator(value: status['shipping'])),
      SvgPicture.asset(
        'assets/images/home.svg',
        width: 20,
        height: 20,
      ),
    ]);
  }
}
