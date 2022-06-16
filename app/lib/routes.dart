import 'package:app/screens/add_card/add_card.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/cart/update_address/update_address_screen.dart';
import 'package:app/screens/cart/voucher/voucher_page.dart';
import 'package:app/screens/home/account/update_account_screen.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/screens/order/order.dart';
import 'package:app/screens/order_management/details.dart';
import 'package:app/screens/order_management/order_management_screen.dart';
import 'package:app/screens/payment/payment.dart';
import 'package:app/screens/search/search.dart';
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
  AddCard.routeName: (context) => const AddCard(),
  OrderScreen.routeName: (context) => const OrderScreen(),
  AddressPage.routeName: (context) => AddressPage(),
  AccountPage.routeName: (context) => AccountPage(),
  SearchScreen.routeName: (context) => const SearchScreen(),
  OrderManagement.routeName: (context) => const OrderManagement(),
  OrderDetail.routeName: ((context) => const OrderDetail())
};
