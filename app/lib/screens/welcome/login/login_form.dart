import 'package:app/share/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

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
                  TextFormField(
                    key: const Key("emailField"),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (val) => {},
                    decoration: InputDecoration(
                      labelText: "Email *",
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
                  PrimaryButton(onPressed: () {}, text: "Login")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
