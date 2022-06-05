import 'dart:convert';

import 'package:app/models/api/base_response.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentService {
  static final Map<String, dynamic> _nullSafety = {
    "id": "",
    "card": {
      "brand": "",
      "exp_month": 0,
      "exp_year": 0,
      "last4": "",
    },
  };
  static dynamic _defaultMethod;
  dynamic get defaultMethod => _defaultMethod;

  static fetchDefaultMethod() async {
    var response = await ApiService().get('/api/payments/methods/default');
    if (response.statusCode == 200) {
      var decoded = responseFromJson(response.body).data;
      PaymentService._defaultMethod = decoded;
      return decoded;
    }
    return _nullSafety;
  }

  static fetchSavedPaymentMethodList() async {
    var response = await ApiService().get("/api/payments/cards/saved");
    if (response.statusCode == 200) {
      /* var defaultMethod = await getDefaultMethod(); */
      return responseFromJson(response.body).data;
      /* setState(() { */
      /*   savedPaymentMethods = responseFromJson(response.body).data; */
      /*   print(savedPaymentMethods); */
      /*   var selected = savedPaymentMethods! */
      /*       .firstWhere((element) => element['id'] == defaultMethod['id']); */
      /*   choosenMethodId = selected['id'] ?? PaymentMethods['stripe']; */
      /* }); */
    }
    return [_nullSafety];
  }

  static addCard(String id) async {
    var response = await ApiService().post(
        "/api/payments/stripe/card/add",
        json.encode({
          "paymentMethodId": id,
        }));
    if (response.statusCode == 200) {
      return responseFromJson(response.body).data;
    }
    return _nullSafety;
  }

  static updateDefaultMethod(String id) async {
    var response = await ApiService()
        .put("/api/payments/methods/default/update", {"payment_method_id": id});
    if (response.statusCode == 200) {
      return responseFromJson(response.body).data;
    }
    return _nullSafety;
  }

  static Future<Map<String, dynamic>> checkout(
      context, dynamic paymentMethod, String address) async {
    try {
      var cartId = await GlobalStorage.read(key: "cart_id");
      var voucherId = await GlobalStorage.read(key: "voucher_id");
      var response = await ApiService().post(
          "/api/payments/stripe/confirm",
          json.encode({
            "payment_method": paymentMethod['id'],
            "address": address,
            "cart_id": cartId,
            "voucher_id": voucherId
          }));
      if (response.statusCode == 200) {
        return responseFromJson(response.body).data;
      } else {
        FToast().init(context).showToast(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                  color: Color(0xfffa5252),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/error.svg",
                    width: 18,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    "An error has occured",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            /* backgroundColor: const Color(0xfffa5252), */
            gravity: ToastGravity.CENTER,
            toastDuration: const Duration(seconds: 3),
            positionedToastBuilder: (context, child) {
              return Positioned(child: child, top: 150, left: 80);
            });
        return {"error": true};
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Failed to complete order due to some error");
      return {"error": true};
    }
  }
}
