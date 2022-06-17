import 'package:app/components/default_button.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/share/constants/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../../models/users/users.dart';

class AddressDetail extends StatefulWidget {
  @override
  _AddressDetailState createState() => _AddressDetailState();
}

class _AddressDetailState extends State<AddressDetail> {
  final addressInput = TextEditingController();
  final wardInput = TextEditingController();
  final districtInput = TextEditingController();
  final cityInput = TextEditingController();
  late Future<dynamic> userAddress;

  @override
  void initState() {
    super.initState();
    userAddress = User().getUserAddress();
    getUserAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: FutureBuilder<dynamic>(
            future: userAddress,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      addressTextFormField(),
                      const SizedBox(
                        height: 15,
                      ),
                      wardFormField(),
                      const SizedBox(
                        height: 15,
                      ),
                      districtTextFormField(),
                      const SizedBox(
                        height: 15,
                      ),
                      cityTextFormField(),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: DefaultButton(
                              text: "Save",
                              press: () async {
                                addOrUpdateAddress(
                                    context,
                                    addressInput.text,
                                    wardInput.text,
                                    districtInput.text,
                                    cityInput.text);
                                String? routeName = await GlobalStorage.read(
                                    key: "previousRoute");
                                Navigator.pushNamed(context, routeName!).then((_)=> setState(() {}));
                                await GlobalStorage.write(key: "previousRoute", value: HomePage.routeName);
                              })),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                );
              } else {
                return const Text("failed");
              }
            }));
  }

  TextFormField addressTextFormField() {
    return TextFormField(
      controller: addressInput,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "please input your address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField wardFormField() {
    return TextFormField(
        controller: wardInput,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Please input your ward",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always));
  }

  TextFormField districtTextFormField({String? district}) {
    return TextFormField(
        controller: districtInput,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: district ?? "Please input your district",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always));
  }

  TextFormField cityTextFormField() {
    return TextFormField(
        controller: cityInput,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Please Input your city",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always));
  }

  void addOrUpdateAddress(context, String? address, String? ward,
      String? district, String? city) async {
    try {
      await User().updateAddress(context, address!, ward!, district!, city!);
    } catch (e) {
      return null;
    }
  }

  void getUserAddress() async {
    try {
      var listAddress = await User().getUserAddress();
      if (listAddress.isNotEmpty) {
        addressInput.text = listAddress[0];
        wardInput.text = listAddress[1];
        districtInput.text = listAddress[2];
        cityInput.text = listAddress[3];
      }
    } catch (e) {
      return null;
    }
  }
}
