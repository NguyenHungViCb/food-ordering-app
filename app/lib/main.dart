import 'package:app/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';

void main() async {
  // load environment variables
  // all variables should have an alias in app_config
  await dotenv.load();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: WelcomeScreen.routeName,
    routes: routes,
    theme: ThemeData(primaryColor: const Color.fromARGB(1, 238, 77, 42)),
  ));
}
