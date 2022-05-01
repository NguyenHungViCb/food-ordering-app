class SucceededInserts
{
  int productId;
  int quantity;

  SucceededInserts(this.productId, this.quantity);

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "quantity":quantity
  };
}