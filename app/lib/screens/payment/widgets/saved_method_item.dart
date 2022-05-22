import 'package:app/share/constants/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SavedMethodItem extends StatefulWidget {
  final dynamic paymentMethod;
  final Function? onTap;
  final bool isCheck;
  const SavedMethodItem(
      {Key? key, required this.paymentMethod, this.isCheck = false, this.onTap})
      : super(key: key);

  @override
  State<SavedMethodItem> createState() => _SavedMethodItemState();
}

class _SavedMethodItemState extends State<SavedMethodItem> {
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
                widget.paymentMethod['card']["brand"] == 'visa'
                    ? "assets/images/visa.svg"
                    : "assets/images/mastercard.svg",
                width: 30,
              ),
              const SizedBox(width: 15),
              Text(
                "**** **** **** " + widget.paymentMethod['card']['last4'],
              ),
              const SizedBox(width: 15),
              Text(widget.paymentMethod['card']['exp_month'].toString() +
                  "/" +
                  widget.paymentMethod['card']['exp_year'].toString())
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
