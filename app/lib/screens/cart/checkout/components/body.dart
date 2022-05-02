
import 'package:app/screens/welcome/signup/signup_form.dart';
import 'package:app/screens/welcome/signup/signup_header.dart';
import 'package:flutter/cupertino.dart';

import 'checkout_form.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: const [CheckoutForm()],
      ),
    );
  }
}
