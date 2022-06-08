class SucceededInserts
{
  int productId;
  int quantity;

  SucceededInserts(this.productId, this.quantity);

  factory SucceededInserts.fromJson(Map<String, dynamic> json) => SucceededInserts(
      json["product_id"],
      json["quantity"]);
}