import 'package:app/share/text_fields/decoration.dart';
import 'package:app/share/text_fields/validations.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final bool required;
  const TextInput({
    Key? key,
    required this.controller,
    required this.name,
    this.required = false,
  }) : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final String key = const Uuid().v4();

  @override
  build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration:
          commonInputDecoration(widget.name + (widget.required ? " *" : "")),
      validator: (value) {
        return TextFieldValidations.isNotNullOrEmpty(widget.name, value);
      },
    );
  }
}
