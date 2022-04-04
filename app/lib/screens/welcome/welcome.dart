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
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFFEE4D2A)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0)))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.grey[900]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0)))),
                  ),
                ),
              ],
            )
          ],
        )),
      )),
    );
  }
}
