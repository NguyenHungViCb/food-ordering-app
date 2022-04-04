import 'package:app/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const WelcomeScreen(),
    },
    theme: ThemeData(primaryColor: const Color.fromARGB(1, 238, 77, 42)),
  ));
}
