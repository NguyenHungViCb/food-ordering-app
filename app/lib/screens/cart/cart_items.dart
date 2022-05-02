//TODO: Intergrate with API
// import 'dart:convert';
//
// import 'package:app/share/text_fields/email.dart';
// import 'package:app/share/text_fields/password.dart';
// import 'package:app/share/text_fields/text.dart';
// import 'package:app/share/text_fields/verify_password.dart';
// import 'package:flutter/material.dart';
// import 'package:app/share/buttons/primary_button.dart';
// import 'package:app/models/cart/getcart/cart.dart';
//
// import '../../size_config.dart';
// class CartScreen extends StatefulWidget {
//   static String routeName = "/cart";
//   const CartScreen({Key? key}) : super(key: key);
//
//   @override
//   CartItemsState createState() => CartItemsState();
// }
//
// class CartItemsState extends State<CartScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late Future<GetCartResponse> cart;
//   @override
//   void initState() {
//     super.initState();
//     cart = CartItems().GetCart();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fetch Data Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Fetch Data Example'),
//         ),
//         body: Center(
//           child: FutureBuilder<GetCartResponse>(
//             future: cart,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 // "\$${snapshot.data!.userId}"
//                 return Text.rich(TextSpan(text:"\$${snapshot.data!.userId.toString()}"));
//               } else if (snapshot.hasError) {
//                 return Text('${snapshot.error}');
//               }
//
//               // By default, show a loading spinner.
//               return const CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
//   }
