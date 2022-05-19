import 'package:app/screens/payment/widgets/method_item.dart';
import 'package:flutter/material.dart';

class MethodList extends StatefulWidget {
  final List<Map<String, String>> paymentMethods;
  final String? name;
  final Function? changePaymentMethod;
  const MethodList(
      {Key? key,
      required this.paymentMethods,
      this.name,
      this.changePaymentMethod})
      : super(key: key);

  @override
  State<MethodList> createState() => _MethodListState();
}

class _MethodListState extends State<MethodList> {
  int choosenMethod = -1;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: widget.paymentMethods.length + (widget.name != null ? 1 : 0),
      itemBuilder: (context, index) => index == 0 && widget.name != null
          ? Text(widget.name as String)
          : MethodItem(
              paymentMethod:
                  widget.paymentMethods[index - (widget.name != null ? 1 : 0)],
              isCheck: choosenMethod == index - 1,
              onTap: (context) {
                setState(() {
                  choosenMethod = index - 1;
                });
                widget.changePaymentMethod!(context, index - 1);
              },
            ),
    );
  }
}
