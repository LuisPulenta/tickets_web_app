import 'dart:convert';

import 'package:tickets_web_app/models/models.dart';

Company companyFromJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Company data) => json.encode(data.toJson());

class Company {
  int id;
  String name;
  String createDate;
  String createUserId;
  String createUserName;
  String lastChangeDate;
  String lastChangeUserId;
  String lastChangeUserName;
  bool active;
  String photo;
  String photoFullPath;
  List<User>? users;
  int usersNumber;

  Company({
    required this.id,
    required this.name,
    required this.createDate,
    required this.createUserId,
    required this.createUserName,
    required this.lastChangeDate,
    required this.lastChangeUserId,
    required this.lastChangeUserName,
    required this.active,
    required this.photo,
    required this.photoFullPath,
    required this.users,
    required this.usersNumber,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        createDate: json["createDate"],
        createUserId: json["createUserId"],
        createUserName: json["createUserName"],
        lastChangeDate: json["lastChangeDate"],
        lastChangeUserId: json["lastChangeUserId"],
        lastChangeUserName: json["lastChangeUserName"],
        active: json["active"],
        photo: json["photo"],
        photoFullPath: json["photoFullPath"],
        users: json["users"] != null
            ? List<User>.from(json["users"].map((x) => User.fromJson(x)))
            : [],
        usersNumber: json["usersNumber"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createDate": createDate,
        "createUserId": createUserId,
        "createUserName": createUserName,
        "lastChangeDate": lastChangeDate,
        "lastChangeUserId": lastChangeUserId,
        "lastChangeUserName": lastChangeUserName,
        "active": active,
        "photo": photo,
        "photoFullPath": photoFullPath,
        "users": users != null
            ? List<dynamic>.from(users!.map((x) => x.toJson()))
            : [],
        "usersNumber": usersNumber,
      };
}
