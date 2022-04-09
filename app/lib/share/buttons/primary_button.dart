import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  const PrimaryButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed(context);
      },
      child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700),
          )),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF0f172a)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)))),
    );
  }
}
