import 'package:app/components/default_button.dart';
import 'package:app/models/users/users.dart';
import 'package:app/screens/cart/update_address/update_address_screen.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({Key? key}) : super(key: key);

  @override
  AddressFormState createState() => AddressFormState();
}

class AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  late Future<GetUserInfo> userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = User().getUserInformation();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FutureBuilder<GetUserInfo>(
        future: userInfo,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30),
                        const Text("Delivery to:"),
                        const SizedBox(height: 10),
                        const Divider(
                            color: Colors.amber, height: 4),
                        const Divider(
                            color: Colors.black, height: 8),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(snapshot.data!.firstName + " " + snapshot.data!.lastName +
                                ' || '  ),
                            Text(snapshot.data?.phoneNumber ?? "0797732463"),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(snapshot.data!.address),
                        const Divider(
                            color: Colors.white, height: 10),
                        const SizedBox(height: 15),
                        DefaultButton(
                          press:() async {
                            Navigator.pushNamed(context, AddressPage.routeName).then((_) => setState(() {}));
                          },
                          text: "Edit",
                        )
                        // )
                      ],
                    ),
                  ],
                ));
          }
          else
            {
              return Expanded(
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 30),
                          const Text("Delivery to:"),
                          const SizedBox(height: 10),
                          const Text("Please add your address"),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          DefaultButton(
                            press:() {
                              Navigator.pushNamed(context, AddressPage.routeName);
                            },
                            text: "Add",
                          )
                          // )
                        ],
                      ),
                    ],
                  ));
            }
        }
          ),
    );
  }
}
