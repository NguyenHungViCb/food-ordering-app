import 'package:app/screens/cart/update_address/components/update_address_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class AddressPage extends StatelessWidget {
  static String routeName="./address";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: buildAppBar(context),
      body: AddressDetail(),
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
            "Your Address",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}