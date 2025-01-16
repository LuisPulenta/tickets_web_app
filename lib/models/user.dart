import 'package:tickets_web_app/models/models.dart';

class User {
  String id;
  String firstName;
  String lastName;
  int userTypeId;
  String userTypeName;
  String email;
  bool emailConfirm;
  String phoneNumber;
  int companyId;
  String companyName;
  String createDate;
  String createUserId;
  String createUserName;
  String lastChangeDate;
  String lastChangeUserId;
  String lastChangeUserName;
  bool active;
  List<TicketCab> tickets;
  String fullName;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userTypeId,
    required this.userTypeName,
    required this.email,
    required this.emailConfirm,
    required this.phoneNumber,
    required this.companyId,
    required this.companyName,
    required this.createDate,
    required this.createUserId,
    required this.createUserName,
    required this.lastChangeDate,
    required this.lastChangeUserId,
    required this.lastChangeUserName,
    required this.active,
    required this.tickets,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userTypeId: json["userTypeId"],
        userTypeName: json["userTypeName"],
        email: json["email"],
        emailConfirm: json["emailConfirm"],
        phoneNumber: json["phoneNumber"],
        companyId: json["companyId"],
        companyName: json["companyName"],
        createDate: json["createDate"],
        createUserId: json["createUserId"],
        createUserName: json["createUserName"],
        lastChangeDate: json["lastChangeDate"],
        lastChangeUserId: json["lastChangeUserId"],
        lastChangeUserName: json["lastChangeUserName"],
        active: json["active"],
        tickets: json["tickets"] != null
            ? List<TicketCab>.from(
                json["tickets"].map((x) => TicketCab.fromJson(x)))
            : [],
        fullName: json["fullName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "userTypeId": userTypeId,
        "userTypeName": userTypeName,
        "email": email,
        "emailConfirm": emailConfirm,
        "phoneNumber": phoneNumber,
        "companyId": companyId,
        "companyName": companyName,
        "createDate": createDate,
        "createUserId": createUserId,
        "createUserName": createUserName,
        "lastChangeDate": lastChangeDate,
        "lastChangeUserId": lastChangeUserId,
        "lastChangeUserName": lastChangeUserName,
        "active": active,
        "tickets": tickets != null
            ? List<dynamic>.from(tickets!.map((x) => x.toJson()))
            : [],
        "fullName": fullName,
      };
}
