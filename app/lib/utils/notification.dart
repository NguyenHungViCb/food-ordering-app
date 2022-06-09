import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

Map<String, int> notificationStatus = {
  "success": 0xff40c057,
  "error": 0xfffa5252
};

void showNotify(context, String status, String message) {
  FToast().init(context).showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Color(notificationStatus[status] != null
                ? notificationStatus[status] as int
                : 0xff4263eb),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/images/error.svg",
              width: 18,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 3),
      positionedToastBuilder: (context, child) {
        return Positioned(child: child, top: 150, left: 80);
      });
}
