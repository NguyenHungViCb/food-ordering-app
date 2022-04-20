// =================== Auth related models ===================

class LocalSignupRequest {
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmPass;
  LocalSignupRequest(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.confirmPass});

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "confirm_pass": confirmPass
      };
}
