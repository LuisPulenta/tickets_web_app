import 'dart:convert';

EmailResponse emailResponseFromJson(String str) =>
    EmailResponse.fromJson(json.decode(str));

String emailResponseToJson(EmailResponse data) => json.encode(data.toJson());

class EmailResponse {
  String emails;

  EmailResponse({
    required this.emails,
  });

  factory EmailResponse.fromJson(Map<String, dynamic> json) => EmailResponse(
        emails: json['emails'],
      );

  Map<String, dynamic> toJson() => {
        'emails': emails,
      };
}
