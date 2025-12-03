import 'dart:convert';

import 'user.dart';

AuthResponse authResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  String token;
  DateTime expiration;
  User user;

  AuthResponse({
    required this.token,
    required this.expiration,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json['token'],
        expiration: DateTime.parse(json['expiration']),
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'expiration': expiration.toIso8601String(),
        'user': user.toJson(),
      };
}
