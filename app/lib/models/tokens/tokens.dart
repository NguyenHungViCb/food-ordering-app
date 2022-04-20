class Token {
  String token;
  String refreshToken;
  Token({required this.token, required this.refreshToken});

  factory Token.fromJson(Map<String, dynamic> json) =>
      Token(token: json['token'], refreshToken: json['refresh_token']);
  Map<String, String> toJson() =>
      {"token": token, "refreshToken": refreshToken};
}
