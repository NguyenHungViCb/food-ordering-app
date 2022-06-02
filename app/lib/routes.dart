import 'package:app/screens/add_card/add_card.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/cart/voucher/voucher_page.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/screens/payment/payment.dart';
import 'package:app/screens/welcome/welcome.dart';
import 'package:flutter/widgets.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  CartScreen.routeName: (context) => CartScreen(),
  VouchersScreen.routeName: (context) => VouchersScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
  HomePage.routeName: (context) => const HomePage(),
  Payment.routeName: (context) => const Payment(),
  AddCard.routeName: (context) => const AddCard()
};
