import 'package:app/components/default_button.dart';
import 'package:flutter/material.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({Key? key}) : super(key: key);

  @override
  VoucherPageState createState() => VoucherPageState();
}

class VoucherPageState extends State<VoucherPage> {
  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Expanded(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Text("Note"),
                  TextFormField(
                    controller: noteController,
                    minLines: 6, // any number you need (It works as the rows for the textarea)
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  const SizedBox(height: 15),
                  DefaultButton(
                    press:() {},
                    text: "Save",
                  )
                  // )
                ],
              ),
            ],
          )),
    );
  }
}
