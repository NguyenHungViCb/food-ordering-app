// This file should only be used to store variables that
// will be used across the app

import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: non_constant_identifier_names
final PaymentMethods = {"stripe": "1", "paypal": "2"};
final baseURL = dotenv.env['BASE_URL'] ?? "";
final stripePublicKey = dotenv.env["STRIPE_PUBLIC"] ?? "";
