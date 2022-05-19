import 'package:app/constants.dart';
import 'package:app/models/product/product.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.productResponse,
    required this.index
  }) : super(key: key);

  final Future<GetSingleProductResponse> productResponse;
  final int index;
  final sum = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetSingleProductResponse>(
        future: productResponse,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(15),
            ),
            child:  Row(
              children: [
                SizedBox(
                  width: 88,
                  child: AspectRatio(
                    aspectRatio: 0.88,
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(snapshot.data?.images[0].src.toString() ?? "", fit: BoxFit.fitHeight),
                    ),
                  ),

                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${snapshot.data?.name ?? ""}",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),

                    Text.rich(
                      TextSpan(
                        text: "\$${snapshot.data!.price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: kPrimaryColor),
                        // children: [
                        //   TextSpan(
                        //       text: " x${cart.details[0].stock}",
                        //       style: Theme.of(context).textTheme.bodyText1),
                        // ],
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
