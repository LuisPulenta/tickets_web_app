class UserType {
  int id = 0;
  String userType = '';

  UserType({
    required this.id,
    required this.userType,
  });

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
        id: json["id"],
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userType": userType,
      };
}
