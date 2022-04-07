import 'package:app/screens/welcome/auth_bottom_sheet.dart';
import 'package:app/screens/welcome/login/index.dart';
import 'package:app/screens/welcome/signup/index.dart';
import 'package:app/share/buttons/neutral_button.dart';
import 'package:app/share/buttons/secondary_button.dart';
import '../../share/buttons/neutral_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static String routeName = "/welcome";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Image.asset("assets/images/logo.png"),
                  const Text(
                    "FoodApp",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEE4D2A)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Order everything with your phone",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: SecondaryButton(
                        text: "Login",
                        onPressed: (context) => {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  context: context,
                                  builder: (context) => const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18),
                                        child: AuthBottomSheet(child: Login()),
                                      ))
                            })),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: NeutralButton(
                      onPressed: (context) {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) => const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 18),
                                  child: AuthBottomSheet(child: SignUp()),
                                ));
                      },
                      text: "Sign Up"),
                ),
              ],
            )
          ],
        )),
      )),
    );
  }
}
