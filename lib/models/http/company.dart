import 'dart:convert';

import 'package:tickets_web_app/models/http/user.dart';

List<Company> companyFromJson(String str) =>
    List<Company>.from(json.decode(str).map((x) => Company.fromJson(x)));

String companyToJson(List<Company> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Company {
  int id;
  String name;
  List<User>? users;

  Company({
    required this.id,
    required this.name,
    this.users,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        users: json["users"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "users": users,
      };
}
