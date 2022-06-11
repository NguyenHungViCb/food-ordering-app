import 'dart:convert';
import 'dart:developer';

import 'package:app/models/api/base_response.dart';
import 'package:app/models/tokens/tokens.dart';
import 'package:app/models/users/auth.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/api_service.dart';

// =================== User related models ===================

UserResponse userFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerified,
    this.phoneNumber,
    this.birthday,
    this.avatar,
    this.active,
    this.createdAt,
    this.updatedAt,
  );

  int id;
  String firstName;
  String lastName;
  String email;
  bool emailVerified;
  dynamic phoneNumber;
  dynamic birthday;
  String avatar;
  bool active;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        json["id"],
        json["first_name"],
        json["last_name"],
        json["email"],
        json["email_verified"],
        json["phone_number"],
        json["birthday"],
        json["avatar"],
        json["active"],
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "email_verified": emailVerified,
        "phone_number": phoneNumber,
        "birthday": birthday,
        "avatar": avatar,
        "active": active,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}

// =================== Class responsed for api called ===================

class User {
  Future<dynamic> localSignup(LocalSignupRequest info) async {
    try {
      var response = await ApiService()
          .post("/api/users/signup/local", json.encode(info.toJson()));
      if (response.statusCode == 200) {
        var user = UserResponse.fromJson(responseFromJson(response.body).data);
        return user;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<dynamic> localLogin(String email, String password) async {
    try {
      var cartId = await GlobalStorage.read(key: "cart_id");
      var response = await ApiService().post(
          "/api/users/login/local",
          json.encode(
              {"email": email, "password": password, "cart_id": cartId}));
      if (response.statusCode.toString().startsWith("2")) {
        var tokens = Token.fromJson(responseFromJson(response.body).data);
        return tokens;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
