import 'dart:convert';

import 'models.dart';

Branch branchFromJson(String str) => Branch.fromJson(json.decode(str));

String branchToJson(Branch data) => json.encode(data.toJson());

class Branch {
  int id;
  String name;
  String createDate;
  String createUserId;
  String createUserName;
  String lastChangeDate;
  String lastChangeUserId;
  String lastChangeUserName;
  bool active;
  List<User>? users;
  int usersNumber;

  Branch({
    required this.id,
    required this.name,
    required this.createDate,
    required this.createUserId,
    required this.createUserName,
    required this.lastChangeDate,
    required this.lastChangeUserId,
    required this.lastChangeUserName,
    required this.active,
    required this.users,
    required this.usersNumber,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json['id'],
        name: json['name'],
        createDate: json['createDate'],
        createUserId: json['createUserId'],
        createUserName: json['createUserName'],
        lastChangeDate: json['lastChangeDate'],
        lastChangeUserId: json['lastChangeUserId'],
        lastChangeUserName: json['lastChangeUserName'],
        active: json['active'],
        users: json['users'] != null
            ? List<User>.from(json['users'].map((x) => User.fromJson(x)))
            : [],
        usersNumber: json['usersNumber'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createDate': createDate,
        'createUserId': createUserId,
        'createUserName': createUserName,
        'lastChangeDate': lastChangeDate,
        'lastChangeUserId': lastChangeUserId,
        'lastChangeUserName': lastChangeUserName,
        'active': active,
        'users': users != null
            ? List<dynamic>.from(users!.map((x) => x.toJson()))
            : [],
        'usersNumber': usersNumber,
      };
}
