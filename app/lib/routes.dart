import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/screens/welcome/welcome.dart';
import 'package:flutter/widgets.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  CartScreen.routeName: (context) => CartScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
  HomePage.routeName: (context) => const HomePage(),
};
