import 'package:app/share/text_fields/decoration.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class VerifyPassword extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  const VerifyPassword(
      {Key? key, required this.controller, required this.passwordController})
      : super(key: key);

  @override
  _VerifyPasswordState createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  final String key = const Uuid().v4();

  @override
  build(BuildContext context) {
    return TextFormField(
      key: const Key("verifyPasswordField"),
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: commonInputDecoration("Confirm Password *"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Confirm password cannot be empty";
        }
        if (value != widget.passwordController.value.text) {
          return "Password not match";
        }
        return null;
      },
    );
  }
}
