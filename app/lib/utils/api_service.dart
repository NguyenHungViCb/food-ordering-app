import 'dart:convert';
import 'dart:developer';

import 'package:app/models/tokens/tokens.dart';
import 'package:app/share/constants/app_config.dart';
import 'package:app/share/constants/storage.dart';
import 'package:http/http.dart' as http;

// An abstraction for api called
// Response for setting some common configurations
class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<Token> getToken() async {
    String? savedToken = await GlobalStorage.read(key: "tokens");
    if (savedToken != null) {
      var decoded = json.decode(savedToken);
      return Token(
          token: decoded['token'], refreshToken: decoded["refreshToken"]);
    }
    return Token(token: "", refreshToken: "");
  }

  Future<http.Response> get(url) async {
    Token tokens = await getToken();
    return await http.get(Uri.parse(baseURL + url), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + tokens.token
    });
  }

  Future<http.Response> post(String url, Object body) async {
    Token tokens = await getToken();
    try {
      return await http.post(Uri.parse(baseURL + url),
          headers: {
            'Authorization': 'Bearer ' + tokens.token,
            'Content-Type': 'application/json'
          },
          body: body);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load http post');
    }
  }

  Future<http.Response> put(url, Object? body) async {
    Token tokens = await getToken();
    return await http.put(Uri.parse(baseURL + url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + tokens.token
        },
        body: json.encode(body));
  }
}
