import 'package:flutter/material.dart';

import '../../../share/constants/storage.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: buildAppBar(context),
      body: Body(),
      bottomNavigationBar: const CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDBF30),
      leading: GestureDetector(
        onTap: () async {
          var routeName = await GlobalStorage.read(key: "previousRoute");
          routeName == "details" || routeName == CartScreen.routeName
              ? Navigator.pop(context)
              : Navigator.pushNamed(context, routeName!);
        },
        child: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        children: const [
          SizedBox(
            width: 100,
          ),
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
