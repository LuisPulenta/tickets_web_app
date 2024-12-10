import 'dart:convert';

import 'package:tickets_web_app/models/models.dart';

Token tokenFromJson(String str) => Token.fromJson(json.decode(str));

String tokenToJson(Token data) => json.encode(data.toJson());

class Token {
  String token;
  String expiration;
  User user;

  Token({
    required this.token,
    required this.expiration,
    required this.user,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        token: json["token"],
        expiration: json["expiration"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expiration": expiration,
        "user": user.toJson(),
      };
}
