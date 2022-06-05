import 'package:app/constants.dart';
import 'package:app/models/product/product.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  CartCard({Key? key, required this.productResponse, required this.index})
      : super(key: key);

  final Future<GetSingleProductResponse> productResponse;
  final int index;
  final sum = 0;
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetSingleProductResponse>(
        future: productResponse,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () {
              //pageController.jumpToPage(int.parse(snapshot.data!.id));
              //Navigator.pushNamed(context, HomePage.routeName, );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
              ),
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
                        child: Image.network(snapshot.data?.images[0].src ?? "",
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
                      Text.rich(
                        TextSpan(
                          text: "\$${snapshot.data?.price ?? 100}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
