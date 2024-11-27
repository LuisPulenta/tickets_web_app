class User {
  String firstName = '';
  String lastName = '';
  int userType = 0;
  String company = '';
  int companyId = 0;
  String createDate = '';
  String createUser = '';
  String lastChangeDate = '';
  String lastChangeUser = '';
  bool active = false;
  String fullName = '';
  String id = '';
  String email = '';
  bool emailConfirmed = false;
  String phoneNumber = '';

  User({
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.company,
    required this.companyId,
    required this.createDate,
    required this.createUser,
    required this.lastChangeDate,
    required this.lastChangeUser,
    required this.active,
    required this.fullName,
    required this.id,
    required this.email,
    required this.emailConfirmed,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        userType: json["userType"],
        company: json["company"],
        companyId: json["companyId"],
        createDate: json["createDate"],
        createUser: json["createUser"],
        lastChangeDate: json["lastChangeDate"],
        lastChangeUser: json["lastChangeUser"],
        active: json["active"],
        fullName: json["fullName"],
        id: json["id"],
        email: json["email"],
        emailConfirmed: json["emailConfirmed"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "userType": userType,
        "company": company,
        "companyId": companyId,
        "createDate": createDate,
        "createUser": createUser,
        "lastChangeDate": lastChangeDate,
        "lastChangeUser": lastChangeUser,
        "active": active,
        "fullName": fullName,
        "id": id,
        "email": email,
        "emailConfirmed": emailConfirmed,
        "phoneNumber": phoneNumber,
      };
}
