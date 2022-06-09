import 'package:app/routes.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/share/constants/app_config.dart';
import 'package:app/share/constants/storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublicKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  // load environment variables
  // all variables should have an alias in app_config
  await Stripe.instance.applySettings();
  await GlobalStorage.deleteAll();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: HomePage.routeName,
    routes: routes,
    theme: ThemeData(primaryColor: const Color.fromARGB(1, 238, 77, 42)),
  ));
}
