import 'dart:convert';

import 'package:app/screens/add_card/card.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/utils/api_service.dart';
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
              Expanded(
                child: CreditCard(
                  onSave: (context, CardDetails card) async {
                    await Stripe.instance.dangerouslyUpdateCardDetails(card);
                    final paymentMethod = await Stripe.instance
                        .createPaymentMethod(const PaymentMethodParams.card(
                      paymentMethodData: PaymentMethodData(),
                    ));
                    try {
                      final response = await ApiService().post(
                          "/api/payments/stripe/card/add",
                          json.encode({
                            "paymentMethodId": paymentMethod.id,
                          }));
                      if (response.statusCode == 200) {
                        Navigator.of(context).popUntil((route) {
                          if (route.settings.name == CartScreen.routeName) {
                            return true;
                          }
                          return false;
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
