import 'package:app/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../models/users/users.dart';

class AccountDetail extends StatefulWidget {
  @override
  _AccountDetailState createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  final addressInput = TextEditingController();
  final wardInput = TextEditingController();
  final districtInput = TextEditingController();
  final cityInput = TextEditingController();
  late Future<dynamic> userAddress;

  @override
  void initState() {
    super.initState();
    userAddress = User().getUserAddress();
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
                      addressTextFormField(address: snapshot.data![0]),
                      const SizedBox(
                        height: 15,
                      ),
                      wardFormField(ward: snapshot.data![1]),
                      const SizedBox(
                        height: 15,
                      ),
                      districtTextFormField(district: snapshot.data![2]),
                      const SizedBox(
                        height: 15,
                      ),
                      cityTextFormField(city: snapshot.data![3]),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: DefaultButton(
                              text: "Save",
                              press: () async {
                                // Replace this hard code id by allow user to select voucher
                                // You can pass null to skip apply voucher
                                addOrUpdateAddress(
                                    addressInput.text == "" ? snapshot.data[0] : addressInput.text,
                                    wardInput.text == "" ? snapshot.data[1] : wardInput.text,
                                    districtInput.text == "" ? snapshot.data[2] : districtInput.text,
                                    cityInput.text == "" ? snapshot.data[3] : cityInput.text);
                                Navigator.pop(context);
                              })),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("Address"),
                      addressTextFormField(),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("Ward"),
                      wardFormField(),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("District"),
                      districtTextFormField(),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("City"),
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
                                // Replace this hard code id by allow user to select voucher
                                // You can pass null to skip apply voucher
                                addOrUpdateAddress(
                                    addressInput.text,
                                    wardInput.text,
                                    districtInput.text,
                                    cityInput.text);
                                Navigator.pop(context);
                              })),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                );
              }
            }));
  }

  TextFormField addressTextFormField({String? address}) {
    return TextFormField(
      controller: addressInput,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: address ?? "please input your address",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,)
    );
  }

  TextFormField wardFormField({String? ward}) {
    return TextFormField(
      controller: wardInput,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: ward ?? "Please input your ward",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always)
    );
  }

  TextFormField districtTextFormField({String? district}) {
    return TextFormField(
      controller: districtInput,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: district ?? "Please input your district",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always)
    );
  }

  TextFormField cityTextFormField({String? city}) {
    return TextFormField(
      controller: cityInput,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: city ?? "Please Input your city",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always)
    );
  }

  void addOrUpdateAddress(String? address, String? ward, String? district, String? city) async {
    try {
      await User().updateAddress(address!, ward!, district!, city!);
    } catch (e) {
      return null;
    }
  }
}
