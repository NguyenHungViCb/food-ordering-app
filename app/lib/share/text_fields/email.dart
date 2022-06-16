import 'package:app/share/text_fields/decoration.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Email extends StatefulWidget {
  final TextEditingController controller;
  const Email({Key? key, required this.controller}) : super(key: key);

  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final String key = const Uuid().v4();

  @override
  build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      keyboardType: TextInputType.emailAddress,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: commonInputDecoration("Phone number *"),
      validator: (value) {
        if (value != null &&
            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return "Email not valid";
        } else if (value == null || value == '') {
          return "Email must not be empty";
        }
        return null;
      },
    );
  }
}
