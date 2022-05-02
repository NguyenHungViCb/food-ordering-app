import 'dart:convert';

// A generic class for response
class BaseResponse<T> {
  String? message;
  T data;
  bool success;

  BaseResponse({this.message = '', required this.data, required this.success});

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
      message: json['message'], data: json['data'], success: json['success']);
}

// Used this to convert response from api for convenience
BaseResponse responseFromJson<T>(String str) =>
    BaseResponse<T>.fromJson(json.decode(str));
