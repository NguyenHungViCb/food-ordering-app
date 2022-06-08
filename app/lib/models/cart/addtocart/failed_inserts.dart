class FailedInserts
{
  String productId;
  int quantity;

  FailedInserts(this.productId, this.quantity);

  factory FailedInserts.fromJson(Map<String, dynamic> json) => FailedInserts(
      json['item']["product_id"],
      json['item']["quantity"]);
}
