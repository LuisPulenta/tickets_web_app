import 'package:tickets_web_app/models/http/user.dart';

class Token {
  String token = '';
  String expiration = '';
  User user = User(
      firstName: '',
      lastName: '',
      companyId: 0,
      userType: 0,
      fullName: '',
      id: '',
      userName: '',
      email: '',
      emailConfirmed: false,
      phoneNumber: '');

  Token({required this.token, required this.expiration, required this.user});

  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expiration'] = expiration;
    data['user'] = user.toJson();
    return data;
  }
}
