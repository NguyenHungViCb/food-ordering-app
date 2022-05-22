class CustomCreditCard {
  String? number;
  int? expirationYear;
  int? expirationMonth;
  String? cvc;
  CustomCreditCard(
      {this.number, this.expirationYear, this.expirationMonth, this.cvc});

  Map<String, dynamic> toJson() {
    return {
      "number": number,
      "expirationYear": expirationYear,
      "expirationMonth": expirationMonth,
      "cvc": cvc
    };
  }
}
