import 'dart:convert';

import 'models.dart';

Subcategory subcategoryFromJson(String str) =>
    Subcategory.fromJson(json.decode(str));

String subcategoryToJson(Category data) => json.encode(data.toJson());

class Subcategory {
  int id;
  int categoryId;
  String categoryName;
  String name;

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json['id'],
        categoryId: json['categoryId'],
        categoryName: json['categoryName'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'name': name,
      };
}
