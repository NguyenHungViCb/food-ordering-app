import 'package:flutter/material.dart';

import 'components/body.dart';

class VouchersScreen extends StatelessWidget {
  static String routeName = "/vouchers";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: buildAppBar(context),
      body: const VoucherPage(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDBF30),
      leading: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        children: const [
          SizedBox(width: 80,),
          Text(
            "Your Vouchers",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
