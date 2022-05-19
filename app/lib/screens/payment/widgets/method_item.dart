import 'package:app/share/constants/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MethodItem extends StatefulWidget {
  final Map<String, String> paymentMethod;
  final Function? onTap;
  final bool isCheck;
  const MethodItem(
      {Key? key, required this.paymentMethod, this.isCheck = false, this.onTap})
      : super(key: key);

  @override
  State<MethodItem> createState() => _MethodItemState();
}

class _MethodItemState extends State<MethodItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        onTap: () {
          GlobalStorage.write(
              key: "payment_method", value: widget.paymentMethod["id"]);
          widget.onTap!(context);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SvgPicture.asset(
                widget.paymentMethod['src']!,
                width: 30,
              ),
              const SizedBox(width: 15),
              Text(
                widget.paymentMethod['name']!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              )
            ]),
            widget.isCheck
                ? SvgPicture.asset('assets/images/check.svg')
                : const SizedBox.shrink()
          ]),
        ),
      ),
    );
  }
}
