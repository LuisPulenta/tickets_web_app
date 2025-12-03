import 'dart:convert';

TicketDet ticketDetFromJson(String str) => TicketDet.fromJson(json.decode(str));

String ticketDetToJson(TicketDet data) => json.encode(data.toJson());

class TicketDet {
  int id;
  String description;
  String ticketState;
  String stateDate;
  String stateUserId;
  String stateUserName;
  String? image;
  String imageFullPath;

  TicketDet({
    required this.id,
    required this.description,
    required this.ticketState,
    required this.stateDate,
    required this.stateUserId,
    required this.stateUserName,
    required this.image,
    required this.imageFullPath,
  });

  factory TicketDet.fromJson(Map<String, dynamic> json) => TicketDet(
        id: json['id'],
        description: json['description'],
        ticketState: json['ticketState'],
        stateDate: json['stateDate'],
        stateUserId: json['stateUserId'],
        stateUserName: json['stateUserName'],
        image: json['image'],
        imageFullPath: json['imageFullPath'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'ticketState': ticketState,
        'stateDate': stateDate,
        'stateUserId': stateUserId,
        'stateUserName': stateUserName,
        'image': image,
        'imageFullPath': imageFullPath,
      };
}
