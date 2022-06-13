import 'package:app/screens/home/account/components/update_account_form.dart';
import 'package:flutter/material.dart';

import '../home.dart';


class AccountPage extends StatelessWidget {
  static String routeName="/account";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: buildAppBar(context),
      body: AccountDetail(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDBF30),
      leading: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, HomePage.routeName);
        },
        child: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        children: const [
          SizedBox(width: 80,),
          Text(
            "Your Information",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}