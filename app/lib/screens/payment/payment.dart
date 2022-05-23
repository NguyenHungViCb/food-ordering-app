import 'dart:convert';
import 'package:app/models/api/base_response.dart';
import 'package:app/screens/add_card/add_card.dart';
import 'package:app/screens/payment/widgets/method_list.dart';
import 'package:app/screens/payment/widgets/saved_method_list.dart';
import 'package:app/share/buttons/yellow_button.dart';
import 'package:app/share/constants/app_config.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/api_service.dart';
import 'package:app/utils/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class Payment extends StatefulWidget {
  static final List<Map<String, String>> paymentMethods = [
    {
      "id": PaymentMethods['stripe']!,
      'src': 'assets/images/stripe.svg',
      'name': "Stripe"
    },
    {
      "id": PaymentMethods['paypal']!,
      'src': 'assets/images/paypal.svg',
      'name': "Paypal"
    },
  ];
  static String routeName = "/payment";
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List<dynamic>? savedPaymentMethods;
  final CardDetails _card = CardDetails();
  int choosenMethod = -1;
  String? choosenMethodId;

  @override
  void initState() {
    super.initState();
    getSavedPaymentMethod();
  }

  getSavedPaymentMethod() async {
    var response = await ApiService().get("/api/payments/cards/saved");
    if (response.statusCode == 200) {
      var defaultMethod = await PaymentService.fetchDefaultMethod();
      setState(() {
        savedPaymentMethods = responseFromJson(response.body).data;
        var selected = savedPaymentMethods!
            .firstWhere((element) => element['id'] == defaultMethod['id']);
        choosenMethodId = selected['id'] ?? PaymentMethods['stripe'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackground, // background color main
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: const Text(
            "Choose payment method",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color(0xFFFDBF30),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              savedPaymentMethods != null && savedPaymentMethods!.isNotEmpty
                  ? Flexible(
                      child: SavedMethodList(
                          paymentMethods: savedPaymentMethods!,
                          name: "Saved Methods",
                          selectedMethod: choosenMethodId,
                          changePaymentMethod: changePaymentMethod))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Saved Payment Methods"),
                        const SizedBox(height: 15),
                        Container(
                          width: MediaQuery.of(context).size.width * 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Text("No payment method saved")),
                        )
                      ],
                    ),
              const SizedBox(
                height: 30,
              ),
              Flexible(
                child: MethodList(
                  paymentMethods: Payment.paymentMethods,
                  name: "Payment Methods",
                  changePaymentMethod: changePaymentMethod,
                  selectedMethod: choosenMethodId,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 100,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: YellowButton(
                        onPressed: (context) async {
                          if (choosenMethodId != null &&
                              choosenMethodId == PaymentMethods['stripe']) {
                            Navigator.pushNamed(context, AddCard.routeName);
                          } else {
                            await PaymentService.updateDefaultMethod(
                                choosenMethodId as String);
                            Navigator.pop(context);
                          }
                        },
                        text: "Confirm")),
              )
            ],
          ),
        ));
  }

  Future<void> _handlePayPress() async {
    await Stripe.instance.dangerouslyUpdateCardDetails(_card);

    try {
      // 1. Gather customer billing information (ex. email)

      // 2. Create payment method
      final paymentMethod = await Stripe.instance
          .createPaymentMethod(const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ));

      String? cartId = await GlobalStorage.read(key: "cart_id");
      // 3. call API to create PaymentIntent
      final response = await ApiService().post(
          "/api/payments/stripe",
          json.encode({
            "useStripeSdk": true,
            "paymentMethodId": paymentMethod.id,
            "currency": 'usd', // mocked data
            "cart_id": cartId
          }));
      print(json.decode(response.body).data);

      /* if (paymentIntentResult['error'] != null) { */
      /*   // Error during creating or confirming Intent */
      /*   ScaffoldMessenger.of(context).showSnackBar( */
      /*       SnackBar(content: Text('Error: ${paymentIntentResult['error']}'))); */
      /*   return; */
      /* } */

      /* if (paymentIntentResult['clientSecret'] != null && */
      /*     paymentIntentResult['requiresAction'] == null) { */
      /*   // Payment succedeed */

      /*   ScaffoldMessenger.of(context).showSnackBar(SnackBar( */
      /*       content: */
      /*           Text('Success!: The payment was confirmed successfully!'))); */
      /*   return; */
      /* } */

      /* if (paymentIntentResult['clientSecret'] != null && */
      /*     paymentIntentResult['requiresAction'] == true) { */
      /*   // 4. if payment requires action calling handleCardAction */
      /*   final paymentIntent = await Stripe.instance */
      /*       .handleCardAction(paymentIntentResult['clientSecret']); */

      /*   if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) { */
      /*     // 5. Call API to confirm intent */
      /*     await confirmIntent(paymentIntent.id); */
      /*   } else { */
      /*     // Payment succedeed */
      /*     ScaffoldMessenger.of(context).showSnackBar(SnackBar( */
      /*         content: Text('Error: ${paymentIntentResult['error']}'))); */
      /*   } */
      /* } */
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  changePaymentMethod(context, id) {
    setState(() {
      choosenMethodId = id;
    });
  }
}
