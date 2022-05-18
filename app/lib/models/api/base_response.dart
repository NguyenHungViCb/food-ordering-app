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
class GetResponse<T> {
  T data;
  GetResponse({required this.data});

  factory GetResponse.fromJson(Map<String, dynamic> json) => GetResponse(data: json['cart_details']);
}
// Used this to convert response from api for convenience
BaseResponse responseFromJson<T>(String str) =>
    BaseResponse<T>.fromJson(json.decode(str));

GetResponse getResponseFromJson<T>(String str) =>
    GetResponse<T>.fromJson(json.decode(str));
