import 'package:app/screens/payment/widgets/saved_method_item.dart';
import 'package:flutter/material.dart';

class SavedMethodList extends StatefulWidget {
  final List<dynamic> paymentMethods;
  final String? name;
  final Function? changePaymentMethod;
  final String? selectedMethod;
  const SavedMethodList(
      {Key? key,
      required this.paymentMethods,
      this.name,
      this.changePaymentMethod,
      this.selectedMethod})
      : super(key: key);

  @override
  State<SavedMethodList> createState() => _SavedMethodListState();
}

class _SavedMethodListState extends State<SavedMethodList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: widget.paymentMethods.length + (widget.name != null ? 1 : 0),
      itemBuilder: (context, index) => index == 0 && widget.name != null
          ? Text(widget.name as String)
          : SavedMethodItem(
              paymentMethod:
                  widget.paymentMethods[index - (widget.name != null ? 1 : 0)],
              isCheck: widget.selectedMethod ==
                  widget.paymentMethods[index - (widget.name != null ? 1 : 0)]
                      ['id'],
              onTap: (context) {
                widget.changePaymentMethod!(
                    context,
                    widget.paymentMethods[index - (widget.name != null ? 1 : 0)]
                        ['id']);
              },
            ),
    );
  }
}
