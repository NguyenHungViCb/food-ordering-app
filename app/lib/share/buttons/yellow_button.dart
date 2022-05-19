import 'package:app/constants.dart';
import 'package:flutter/material.dart';

class YellowButton extends StatefulWidget {
  final Function onPressed;
  final String text;
  final bool loading;
  const YellowButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.loading = false})
      : super(key: key);

  @override
  _YellowButtonState createState() => _YellowButtonState();
}

class _YellowButtonState extends State<YellowButton> {
  bool loading = false;
  Color activeBg = kPrimaryColor;
  Color disableBg = kPrimaryColor;
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
          : const Icon(Icons.verified),
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
