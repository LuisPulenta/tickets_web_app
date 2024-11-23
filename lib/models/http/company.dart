import 'dart:convert';

List<Company> companyFromJson(String str) =>
    List<Company>.from(json.decode(str).map((x) => Company.fromJson(x)));

String companyToJson(List<Company> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Company {
  int id;
  String name;
  DateTime createDate;
  String createUser;
  DateTime lastChangeDate;
  String lastChangeUser;
  bool active;
  String? photo;
  String photoFullPath;
  dynamic users;
  int usersNumber;

  Company({
    required this.id,
    required this.name,
    required this.createDate,
    required this.createUser,
    required this.lastChangeDate,
    required this.lastChangeUser,
    required this.active,
    this.photo = '',
    required this.photoFullPath,
    required this.users,
    required this.usersNumber,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        createDate: DateTime.parse(json["createDate"]),
        createUser: json["createUser"],
        lastChangeDate: DateTime.parse(json["lastChangeDate"]),
        lastChangeUser: json["lastChangeUser"],
        active: json["active"],
        photo: json["photo"] ?? '',
        photoFullPath: json["photoFullPath"],
        users: json["users"],
        usersNumber: json["usersNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createDate": createDate.toIso8601String(),
        "createUser": createUser,
        "lastChangeDate": lastChangeDate.toIso8601String(),
        "lastChangeUser": lastChangeUser,
        "active": active,
        "photo": photo,
        "photoFullPath": photoFullPath,
        "users": users,
        "usersNumber": usersNumber,
      };
}
