import 'package:app/models/order/orders.dart';
import 'package:app/models/product/product.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

class OrderItemCard extends StatelessWidget {
  final OrderDetail item;
  const OrderItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetSingleProductResponse>(
        future: ProductItems().getSingleProduct(item.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  SizedBox(
                    width: 88,
                    child: AspectRatio(
                      aspectRatio: 0.88,
                      child: Container(
                        padding:
                            EdgeInsets.all(getProportionateScreenWidth(10)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.network(
                            snapshot.data?.images[0].src.toString() ?? "",
                            fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data?.name ?? "",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              text: "Count: ${item.quantity}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text.rich(
                            TextSpan(
                              text: "Total: \$${item.total}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
