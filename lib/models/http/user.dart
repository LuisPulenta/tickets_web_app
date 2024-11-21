import 'dart:convert';

import 'package:tickets_web_app/models/http/company.dart';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String firstName;
  String lastName;
  int userType;
  Company? company;
  String fullName;
  String id;
  String userName;
  String email;
  bool emailConfirmed;
  String phoneNumber;

  User({
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.company,
    required this.fullName,
    required this.id,
    required this.userName,
    required this.email,
    required this.emailConfirmed,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        userType: json["userType"],
        company: json["company"],
        fullName: json["fullName"],
        id: json["id"],
        userName: json["userName"],
        email: json["email"],
        emailConfirmed: json["emailConfirmed"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "userType": userType,
        "company": company,
        "fullName": fullName,
        "id": id,
        "userName": userName,
        "email": email,
        "emailConfirmed": emailConfirmed,
        "phoneNumber": phoneNumber,
      };
}
