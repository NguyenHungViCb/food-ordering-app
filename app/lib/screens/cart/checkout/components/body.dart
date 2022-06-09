import 'package:flutter/cupertino.dart';

import 'checkout_form.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: const [CheckoutForm()],
      ),
    );
  }
}
