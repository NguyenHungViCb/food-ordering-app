class Error
{
  String message;
  int request;
  int stock;

  Error(this.message, this.request, this.stock);

  Map<String, dynamic> toJson() => {
    "message": message,
    "request":request,
    "stock": stock
  };
}