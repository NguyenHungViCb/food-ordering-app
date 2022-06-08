import 'dart:convert';

import 'package:app/share/constants/storage.dart';

class UserService {
  Future<bool> isLogin() async {
    var savedTokens = await GlobalStorage.read(key: 'tokens');
    if (savedTokens != null) {
      var decoded = json.decode(savedTokens);
      if (decoded["token"] != null) {
        return true;
      }
    }
    return false;
  }
}
