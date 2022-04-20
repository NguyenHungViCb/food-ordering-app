import 'package:app/screens/welcome/signup/signup_form.dart';
import 'package:app/screens/welcome/signup/signup_header.dart';
import 'package:flutter/cupertino.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: const [SignupHeader(), SignupForm()],
      ),
    );
  }
}
