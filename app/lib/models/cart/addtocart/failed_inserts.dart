class FailedInserts
{
  int productId;
  int quantity;

  FailedInserts(this.productId, this.quantity);

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "quantity":quantity
  };
}