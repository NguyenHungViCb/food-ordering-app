import 'dart:convert';

import 'package:app/models/api/base_response.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/api_service.dart';

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

  Future<dynamic> getUserInfo() async {
    var userInfo = await GlobalStorage.read(key: "user_info");
    if (userInfo == null) {
      var response = await ApiService().get("/api/users/auth/info/single");
      var result = await responseFromJson(response.body).data;
      await GlobalStorage.write(key: "user_info", value: json.encode(result));
      return result;
    }
    return json.decode(userInfo);
  }
  static String? validateEmail(String value)
  {
    if(value.isEmpty)
    {
      return 'Please enter mail';
    }

    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if(!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }
}
