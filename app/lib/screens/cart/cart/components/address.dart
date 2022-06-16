import 'package:flutter/material.dart';

class AddressInformation extends StatelessWidget {
  AddressInformation({Key? key, required this.userAddress}) : super(key: key);
  final Future<List<String>> userAddress;
  late bool checkUserAddress;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: userAddress,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return Text(address(snapshot.data));
            } else {
              return const Text("Add address");
            }
          } else {
            return const Text("failed");
          }
        });
  }

  String address(List<String>? addressInfo) {
    var address = addressInfo?.join(", ").trim();
    return address!;
  }
}
