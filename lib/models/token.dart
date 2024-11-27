import 'package:tickets_web_app/models/models.dart';

class Token {
  String token = '';
  String expiration = '';
  User user = User(
      firstName: '',
      lastName: '',
      userType: 0,
      company: '',
      companyId: 0,
      createDate: '',
      createUser: '',
      lastChangeDate: '',
      lastChangeUser: '',
      active: false,
      fullName: '',
      id: '',
      email: '',
      emailConfirmed: false,
      phoneNumber: '');

  Token({
    required this.token,
    required this.expiration,
    required this.user,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        token: json["token"],
        expiration: json["expiration"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expiration": expiration,
        "user": user.toJson(),
      };
}
