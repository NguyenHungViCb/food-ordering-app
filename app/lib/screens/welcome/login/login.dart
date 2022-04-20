import 'package:app/models/users/users.dart';
import 'package:flutter/material.dart';
import 'login_form.dart';
import 'login_header.dart';

class Login extends StatefulWidget {
  final UserResponse? user;
  const Login({Key? key, this.user}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: <Widget>[
          const LoginHeader(),
          LoginForm(
            user: widget.user,
          ),
        ],
      ),
    );
  }
}
