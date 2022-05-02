import 'package:app/models/tokens/tokens.dart';
import 'package:app/share/constants/app_config.dart';
import 'package:http/http.dart' as http;

// An abstraction for api called
// Response for setting some common configurations
class ApiService {
  static final ApiService _instance = ApiService._internal();
  Token tokens = Token(token: "", refreshToken: "");

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<http.Response> get(url) async {
    return await http.get(Uri.parse(baseURL + url), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer' + tokens.token
    });
  }

  Future<http.Response> post(String url, Object body) async {
    return await http.post(Uri.parse(baseURL + url),
        headers: {
          'Authorization': 'Bearer' + tokens.token,
          'Content-Type': 'application/json'
        },
        body: body);
  }
}
