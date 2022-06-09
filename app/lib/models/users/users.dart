import 'dart:convert';
import 'dart:developer';

import 'package:app/models/api/base_response.dart';
import 'package:app/models/tokens/tokens.dart';
import 'package:app/models/users/auth.dart';
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

class GetUserInfo {
  // "id": 1,
  // "first_name": "duc",
  // "last_name": "phan",
  // "birthday": null,
  // "email": "ducmphan@gmail.com",
  // "email_verified": false,
  // "phone_number": null,
  // "password": "123456789",
  // "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjU0NTExMzUxLCJleHAiOjE2NTcxMDMzNTF9.K7kSqsJD4AQeBZSW7gmKvJV7f2mfzYZA3A-4G3-xOk4",
  // "facebook_id": null,
  // "google_id": null,
  // "avatar": "https://scontent.fsgn5-3.fna.fbcdn.net/v/t1.30497-1/cp0/c15.0.50.50a/p50x50/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&ccb=1-5&_nc_sid=12b3be&_nc_ohc=XyWt8Z2JeBcAX894iLG&_nc_ht=scontent.fsgn5-3.fna&edm=AP4hL3IEAAAA&oh=15811581152ebb890135bfd3201e3439&oe=61D27B38",
  // "active": true,
  // "stripe_id": null,
  // "selected_card": null,
  // "address": "test, s, 1, duc",
  // "created_at": "2022-06-05T14:33:45.586Z",
  // "updated_at": "2022-06-06T10:29:11.260Z"

  // "id": 1,
  // "first_name": "duc",
  // "last_name": "phan",
  // "email": "ducmphan@gmail.com",
  // "email_verified": false,
  // "phone_number": null,
  // "birthday": null,
  // "avatar": "https://scontent.fsgn5-3.fna.fbcdn.net/v/t1.30497-1/cp0/c15.0.50.50a/p50x50/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&ccb=1-5&_nc_sid=12b3be&_nc_ohc=XyWt8Z2JeBcAX894iLG&_nc_ht=scontent.fsgn5-3.fna&edm=AP4hL3IEAAAA&oh=15811581152ebb890135bfd3201e3439&oe=61D27B38",
  // "active": true,
  // "created_at": "2022-06-05T14:33:45.586Z",
  // "updated_at": "2022-06-06T11:04:29.765Z",
  // "address": "test, s, 1, duc"
  int id;
  String firstName;
  String lastName;

  String email;
  bool emailVerified;
  dynamic phoneNumber;
  dynamic birthday;
  //String password;
  //String refreshToken;
  // String? facebookId;
  // String? googleId;
  String avatar;
  bool active;
  // String? stripeId;
  // String? selectedCard;

  DateTime createdAt;
  DateTime updatedAt;
  String address;
  GetUserInfo(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerified,
    this.phoneNumber,
    this.birthday,
    //this.password,
    //this.refreshToken,
    // this.facebookId,
    // this.googleId,
    this.avatar,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.address,
  );

  factory GetUserInfo.fromJson(Map<String, dynamic> json) => GetUserInfo(
        json["id"],
        json["first_name"],
        json["last_name"],
        json["email"],
        json["email_verified"],
        json["phone_number"],
        json["birthday"],
        // json["password"],
        // json["refresh_token"],
        // json["facebook_id"],
        // json["google_id"],
        json["avatar"],
        json["active"],
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["created_at"]),
        json["address"],
      );
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
      var response = await ApiService().post("/api/users/login/local",
          json.encode({"email": email, "password": password}));
      if (response.statusCode.toString().startsWith("2")) {
        var tokens = Token.fromJson(responseFromJson(response.body).data);
        return tokens;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<dynamic> updateAddress(String address, String ward, String district, String city ) async {
    try {
      var response = await ApiService().post("/api/users/auth/addresses/update",
          json.encode({"address": address, "ward": ward, "district": district, "city": city}));
      {
    }
      if (response.statusCode.toString().startsWith("2")) {
        var tokens = Token.fromJson(responseFromJson(response.body).data);
        return tokens;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<GetUserInfo> getUserInformation() async {
    try {
      var response = await ApiService().get("/api/users/auth/info/single");
      if (response.statusCode.toString().startsWith("2")) {
        var userInfoResponse =
        GetUserInfo.fromJson(responseFromJson(response.body).data);
        var address = userInfoResponse.address.split(",");
        for(int i = 0; i<address.length;i++)
          {
            print(address[i]);
          }
        return userInfoResponse;
      }
    } catch (e) {
      log(e.toString());
    }
    return Future.error(GetUserInfo);
  }
  Future<dynamic> getUserAddress() async {
    try {
      var response = await ApiService().get("/api/users/auth/info/single");
      if (response.statusCode.toString().startsWith("2")) {
        var userInfoResponse =
        GetUserInfo.fromJson(responseFromJson(response.body).data);
        var address = userInfoResponse.address.split(",");
        for(int i = 0; i<address.length;i++)
        {
          print(address[i]);
        }
        return address;
      }
    } catch (e) {
      log(e.toString());
    }
    return Future.error(GetUserInfo);
  }
}
