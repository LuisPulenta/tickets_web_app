import 'dart:convert';

import 'package:tickets_web_app/models/models.dart';

List<TicketCab> ticketCabFromJson(String str) =>
    List<TicketCab>.from(json.decode(str).map((x) => TicketCab.fromJson(x)));

String ticketCabToJson(List<TicketCab> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketCab {
  int id;
  String createDate;
  String createUserId;
  String createUserName;
  int companyId;
  String companyName;
  int categoryId;
  String categoryName;
  int subcategoryId;
  String subcategoryName;
  String title;
  int ticketState;
  dynamic asignDate;
  String userAsign;
  String userAsignName;
  dynamic inProgressDate;
  dynamic finishDate;
  List<TicketDet>? ticketDets;
  int ticketDetsNumber;

  TicketCab({
    required this.id,
    required this.createDate,
    required this.createUserId,
    required this.createUserName,
    required this.companyId,
    required this.companyName,
    required this.categoryId,
    required this.categoryName,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.title,
    required this.ticketState,
    required this.asignDate,
    required this.userAsign,
    required this.userAsignName,
    required this.inProgressDate,
    required this.finishDate,
    required this.ticketDets,
    required this.ticketDetsNumber,
  });

  factory TicketCab.fromJson(Map<String, dynamic> json) => TicketCab(
        id: json["id"],
        createDate: json["createDate"],
        createUserId: json["createUserId"],
        createUserName: json["createUserName"],
        companyId: json["companyId"],
        companyName: json["companyName"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"] ?? '',
        subcategoryId: json["subcategoryId"],
        subcategoryName: json["subcategoryName"] ?? '',
        title: json["title"],
        ticketState: json["ticketState"],
        asignDate: json["asignDate"],
        userAsign: json["userAsign"] ?? '',
        userAsignName: json["userAsignName"] ?? '',
        inProgressDate: json["inProgressDate"],
        finishDate: json["finishDate"],
        ticketDets: json["ticketDets"] != null
            ? List<TicketDet>.from(
                json["ticketDets"].map((x) => TicketDet.fromJson(x)))
            : [],
        ticketDetsNumber: json["ticketDetsNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createDate": createDate,
        "createUserId": createUserId,
        "createUserName": createUserName,
        "companyId": companyId,
        "companyName": companyName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "subcategoryId": subcategoryId,
        "subcategoryName": subcategoryName,
        "title": title,
        "ticketState": ticketState,
        "asignDate": asignDate,
        "userAsign": userAsign,
        "userAsignName": userAsignName,
        "inProgressDate": inProgressDate,
        "finishDate": finishDate,
        "ticketDets": ticketDets != null
            ? List<TicketDet>.from(ticketDets!.map((x) => x.toJson()))
            : [],
        "ticketDetsNumber": ticketDetsNumber,
      };
}
