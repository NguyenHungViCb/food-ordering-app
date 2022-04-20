import 'package:app/models/users/users.dart';
import 'package:app/screens/welcome/auth_bottom_sheet.dart';
import 'package:app/screens/welcome/login/login.dart';
import 'package:app/screens/welcome/signup/signup.dart';
import 'package:app/screens/welcome/widgets/logo.dart';
import 'package:app/share/buttons/neutral_button.dart';
import 'package:app/share/buttons/secondary_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String routeName = "/welcome";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UserResponse? user;

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
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Logo(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: SecondaryButton(
                        text: "Login",
                        onPressed: (context) {
                          displayBottomSheet(
                              context,
                              AuthBottomSheet(
                                  child: Login(
                                user: user,
                              )));
                        })),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: NeutralButton(
                      onPressed: (context) {
                        displayBottomSheet(
                            context, const AuthBottomSheet(child: SignUp()));
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

  displayBottomSheet(context, Widget sheet) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: sheet,
            )).then((value) => {
          if (value is UserResponse)
            {
              setState(() {
                user = value;
              })
            }
        });
  }
}
