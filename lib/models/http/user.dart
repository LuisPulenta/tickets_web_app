class User {
  String firstName;
  String lastName;
  int userType;
  int companyId;
  String fullName;
  String id;
  String userName;
  String email;
  bool emailConfirmed;
  String phoneNumber;

  User({
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.companyId,
    required this.fullName,
    required this.id,
    required this.userName,
    required this.email,
    required this.emailConfirmed,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        userType: json["userType"],
        companyId: json["companyId"],
        fullName: json["fullName"],
        id: json["id"],
        userName: json["userName"],
        email: json["email"],
        emailConfirmed: json["emailConfirmed"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "userType": userType,
        "companyId": companyId,
        "fullName": fullName,
        "id": id,
        "userName": userName,
        "email": email,
        "emailConfirmed": emailConfirmed,
        "phoneNumber": phoneNumber,
      };
}
