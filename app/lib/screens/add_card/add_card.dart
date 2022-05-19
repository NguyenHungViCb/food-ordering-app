import 'package:app/models/credit_card.dart';
import 'package:app/screens/add_card/card.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/share/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class AddCard extends StatefulWidget {
  static const routeName = "/add-card";

  const AddCard({Key? key}) : super(key: key);

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text(
          "Add Credit Card",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFDBF30),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
          child: Column(
            children: [
              CreditCard(
                onSave: (context, CustomCreditCard card) {
                  Navigator.of(context).popUntil((route) {
                    if (route.settings.name == CartScreen.routeName) {
                      (route.settings.arguments as Map)['result'] = card;
                      return true;
                    }
                    return false;
                  });
                },
              ),
            ],
          )),
    );
  }
}
