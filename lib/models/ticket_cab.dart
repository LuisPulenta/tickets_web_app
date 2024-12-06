import 'dart:convert';

List<TicketCab> ticketCabFromJson(String str) =>
    List<TicketCab>.from(json.decode(str).map((x) => TicketCab.fromJson(x)));

String ticketCabToJson(List<TicketCab> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketCab {
  int id;
  DateTime createDate;
  String createUser;
  String company;
  String title;
  String description;
  int ticketState;
  DateTime stateDate;
  String stateUser;

  TicketCab({
    required this.id,
    required this.createDate,
    required this.createUser,
    required this.company,
    required this.title,
    required this.description,
    required this.ticketState,
    required this.stateDate,
    required this.stateUser,
  });

  factory TicketCab.fromJson(Map<String, dynamic> json) => TicketCab(
        id: json["id"],
        createDate: DateTime.parse(json["createDate"]),
        createUser: json["createUser"],
        company: json["company"],
        title: json["title"],
        description: json["description"],
        ticketState: json["ticketState"],
        stateDate: DateTime.parse(json["stateDate"]),
        stateUser: json["stateUser"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createDate": createDate.toIso8601String(),
        "createUser": createUser,
        "company": company,
        "title": title,
        "description": description,
        "ticketState": ticketState,
        "stateDate": stateDate.toIso8601String(),
        "stateUser": stateUser,
      };
}
