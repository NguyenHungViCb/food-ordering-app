class FailedInserts
{
  int productId;
  int quantity;

  FailedInserts(this.productId, this.quantity);

  factory FailedInserts.fromJson(Map<String, dynamic> json) => FailedInserts(
      json["product_id"],
      json["quantity"]);
}