// This file should only be used to store variables that
// will be used across the app

import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseURL = dotenv.env['BASE_URL'] ?? "";
