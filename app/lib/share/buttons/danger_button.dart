import 'package:flutter/material.dart';

class DangerousButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  const DangerousButton({Key? key, required this.onPressed, required this.text})
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
          backgroundColor: MaterialStateProperty.all(const Color(0xfffa5252)),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)))),
    );
  }
}
