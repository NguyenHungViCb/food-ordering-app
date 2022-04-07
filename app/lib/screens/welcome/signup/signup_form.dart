import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../share/buttons/primary_button.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Expanded(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                bottom: 8.0, top: 24, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                    key: const Key("signUpEmailField"),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (val) {},
                    decoration: InputDecoration(
                        labelText: "Email *",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xfff0f2f6))),
                const SizedBox(height: 30),
                TextFormField(
                  key: const Key("passwordField"),
                  obscureText: true,
                  onSaved: (val) => {},
                  decoration: InputDecoration(
                    labelText: "Password *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xfff0f2f6),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  key: const Key("verifyPasswordField"),
                  obscureText: true,
                  onSaved: (val) => {},
                  decoration: InputDecoration(
                    labelText: "Verify Password *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xfff0f2f6),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Fogot password",
                        style: TextStyle(color: Color(0xFFFA5252)),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text(
                        "Already have account?",
                        style: TextStyle(color: Color(0xFFADB5BD)),
                      ),
                      Text(
                        " Login Now!",
                        style: TextStyle(color: Color(0xFF4C6EF5)),
                      ),
                    ],
                  )
                ]),
                const SizedBox(height: 30),
                PrimaryButton(onPressed: () {}, text: "Sign up")
              ],
            ),
          )
        ],
      )),
    );
  }
}
