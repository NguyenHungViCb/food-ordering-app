import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final Function onPressed;
  final String text;
  final bool loading;
  const PrimaryButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.loading = false})
      : super(key: key);

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool loading = false;
  Color activeBg = const Color(0xFF10192D);
  Color disableBg = const Color(0xFF222E49);
  Color activeFg = Colors.white;
  Color disableFg = Colors.white54;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.loading
          ? () {
              loading ? null : widget.onPressed(context, toggleLoading);
            }
          : () {
              widget.onPressed(context);
            },
      icon: loading
          ? const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.exit_to_app),
      label: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            widget.text,
            style: const TextStyle(fontWeight: FontWeight.w700),
          )),
      style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all(loading ? disableFg : activeFg),
          backgroundColor:
              MaterialStateProperty.all(loading ? disableBg : activeBg),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)))),
    );
  }

  toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }
}
