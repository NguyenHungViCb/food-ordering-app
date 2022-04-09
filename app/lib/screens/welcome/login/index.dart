import 'package:flutter/material.dart';
import 'login_form.dart';
import 'login_header.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: const <Widget>[
          LoginHeader(),
          LoginForm(),
        ],
      ),
    );
  }
}
