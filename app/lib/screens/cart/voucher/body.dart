
import 'package:app/screens/welcome/signup/signup_form.dart';
import 'package:app/screens/welcome/signup/signup_header.dart';
import 'package:flutter/cupertino.dart';

import 'voucher_page.dart';

class Voucher extends StatelessWidget {
  const Voucher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: const [VoucherPage()],
      ),
    );
  }
}
