import 'package:app/share/text_fields/decoration.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Password extends StatefulWidget {
  final TextEditingController controller;
  const Password({Key? key, required this.controller}) : super(key: key);

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final String key = const Uuid().v4();

  @override
  build(BuildContext context) {
    return TextFormField(
      key: Key(key),
      obscureText: true,
      onSaved: (val) => {},
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      decoration: commonInputDecoration("Password *"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password cannot be empty";
        }
        return null;
      },
    );
  }
}
