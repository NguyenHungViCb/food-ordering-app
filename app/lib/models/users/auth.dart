// =================== Auth related models ===================

class LocalSignupRequest {
  String firstName;
  String lastName;
  String phoneNumber;
  String password;
  String confirmPass;
  String? cartId;
  LocalSignupRequest(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.password,
      required this.confirmPass,
      this.cartId});

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "password": password,
        "confirm_pass": confirmPass,
        "cart_id": cartId
      };
}
