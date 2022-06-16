import 'package:app/screens/order_management/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderCard extends StatefulWidget {
  final dynamic order;
  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final Map<String, String> paymentMethods = {
    "mastercard": "assets/images/mastercard.svg",
    "visa": "assets/images/visa.svg",
  };

  @override
  Widget build(BuildContext context) {
    var date = widget.order['paid_at'].split("-");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, OrderDetail.routeName,
              arguments: widget.order['id']);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.order['status']),
                    const Text("\t•\t"),
                    Text("${date[0]}-${date[1]}-${date[2].split('T')[0]}")
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${widget.order['details'][0]['product']['name']} ${widget.order['details'].length > 1 ? "," + widget.order['details'][1]['product']['name'] : ''} ${widget.order['details'].length > 2 ? '...' : ''}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    buildPaymentMethod(widget.order['payment_method']),
                    const SizedBox(
                      width: 15,
                    ),
                    Text("\$${widget.order['total']}"),
                    const Text("\t•\t"),
                    Text("${widget.order['total_items']} items")
                  ],
                )
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }

  buildPaymentMethod(String paymentMethod) {
    return SvgPicture.asset(
      paymentMethods[paymentMethod] as String,
      width: 34,
    );
  }
}
