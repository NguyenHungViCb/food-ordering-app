import 'dart:convert';
import 'package:app/models/tokens/tokens.dart';
import 'package:app/models/users/users.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/cart/cart_items.dart';
import 'package:app/screens/cart/cart_page.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/share/buttons/primary_button.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/share/text_fields/email.dart';
import 'package:app/share/text_fields/password.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final UserResponse? user;
  const LoginForm({Key? key, this.user}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user?.email != null) {
      emailController.text = widget.user?.email as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0, top: 24, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Email(controller: emailController),
                  const SizedBox(height: 30),
                  Password(controller: passwordController),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Checkbox(value: false, onChanged: (bool? value) {}),
                        const Text("Remember me")
                      ]),
                      const Text(
                        "Fogot password",
                        style: TextStyle(color: Color(0xFFFA5252)),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text(
                        "Don't have an account",
                        style: TextStyle(color: Color(0xFFADB5BD)),
                      ),
                      Text(
                        " Signup Now!",
                        style: TextStyle(color: Color(0xFF4C6EF5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(
                      onPressed: loginHandler, text: "Login", loading: true)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginHandler(context, toggleLoading) async {
    toggleLoading();
    await Future.delayed(const Duration(seconds: 1));
     var tokens =
        await User().localLogin(emailController.text, passwordController.text);
     if (tokens is Token) {
       await GlobalStorage.write(
           key: "tokens", value: json.encode(tokens.toJson()));
       GlobalStorage.read(key: "tokens").then((value) => print(value));
       Navigator.pushNamed(context, HomePage.routeName);
     }
    toggleLoading();
  }
}
