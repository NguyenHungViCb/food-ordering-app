// =================== Cart request models ===================

class CartRequest {
  int productId;
  int quantity;

  CartRequest(
      {required this.productId,
        required this.quantity});

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "quantity": quantity,
  };
}
