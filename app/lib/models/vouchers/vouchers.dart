import 'dart:developer';


import 'dart:convert';
import 'package:app/utils/api_service.dart';

GetVouchersResponse productFromJson(String str) =>
    GetVouchersResponse.fromJson(json.decode(str));

class GetVouchersResponse {
  String id;
  String code;
  String description;
  int discount;
  int minValue;
  DateTime validFrom, validUntil;
  String createdAt, updatedAt;

  GetVouchersResponse(
      this.id,
      this.code,
      this.description,
      this.discount,
      this.minValue,
      this.validFrom,
      this.validUntil,
      this.updatedAt,
      this.createdAt
    );

  factory GetVouchersResponse.fromJson(Map<dynamic, dynamic> json) =>
      GetVouchersResponse(
          json["id"],
          json["code"],
          json["description"],
          json["discount"],
          json["min_value"],
          DateTime.parse(json["valid_from"]),
        DateTime.parse(json["valid_until"]),
          json["updated_at"],
          json["created_at"],
          );
}
class VouchersList {
  final List<GetVouchersResponse>? voucherResponse;

  VouchersList(this.voucherResponse);

  VouchersList.fromJson(Map<String, dynamic>? json)
      : voucherResponse = (json?['data'] as List?)
      ?.map((i) => GetVouchersResponse.fromJson(i))
      .toList();
}
class VouchersItems {
  Future<List<GetVouchersResponse>?> getVouchersForCart(int id) async {
    try {
      var response = await ApiService().get("/api/vouchers/applicabled/cart?cart_id=$id");
      final data = json.decode(response.body);
      return VouchersList.fromJson(data).voucherResponse;
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load product');
    }
    }
}
