class ResponseOrder {
  String id;
  String userId;
  String address;
  String status;
  String paymentMethod;
  String paymentDetail;
  String? paidAt;
  String? canceledAt;
  String voucherId;
  String createdAt;
  String updatedAt;
  List<OrderDetail> details;
  dynamic total;
  bool allowCancel;
  Voucher? voucher;
  dynamic originalTotal;

  ResponseOrder(
      this.id,
      this.userId,
      this.address,
      this.status,
      this.paymentMethod,
      this.paymentDetail,
      this.paidAt,
      this.canceledAt,
      this.voucherId,
      this.createdAt,
      this.updatedAt,
      this.details,
      this.total,
      this.allowCancel,
      this.voucher,
      this.originalTotal);

  factory ResponseOrder.fromJson(Map<dynamic, dynamic> json) => ResponseOrder(
      json['id'],
      json['user_id'],
      json['address'],
      json['status'],
      json['payment_method'],
      json['payment_detail'],
      json['paid_at'] ?? '',
      json['canceled_at'] ?? '',
      json['voucher_id'],
      json['created_at'],
      json['updated_at'],
      List<OrderDetail>.from(
          json['details'].map((item) => OrderDetail.fromJson(item))),
      json['total'],
      json['allowCancel'],
      json['voucher'] != null ? Voucher.fromJson(json['voucher']) : null,
      json['original_total']);

  toJson() => {
        "id": id,
        "userId": userId,
        "address": address,
        "status": status,
        "paymentMethod": paymentMethod,
        "paymentDetail": paymentDetail,
        "paidAt": paidAt,
        "canceledAt": canceledAt,
        "voucherId": voucherId,
        "createdAt": createdAt,
        "updatedAt": updatedAt
      };
}

class OrderDetail {
  String id;
  String orderId;
  String productId;
  int quantity;
  String total;
  String createdAt;
  String updatedAt;

  OrderDetail(this.id, this.orderId, this.productId, this.quantity, this.total,
      this.createdAt, this.updatedAt);

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
      json['id'],
      json['order_id'],
      json['product_id'],
      json['quantity'],
      json['total'],
      json['created_at'],
      json['updated_at']);
}

class Voucher {
  String code;
  dynamic discount;
  Voucher(this.code, this.discount);
  factory Voucher.fromJson(Map<String, dynamic> json) =>
      Voucher(json['code'], json['discount']);
}
