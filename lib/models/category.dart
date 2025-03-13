import 'dart:convert';

import 'package:tickets_web_app/models/models.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  int id;
  String name;
  List<Subcategory>? subcategories;
  int subcategoriesNumber;

  Category({
    required this.id,
    required this.name,
    required this.subcategories,
    required this.subcategoriesNumber,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        subcategories: json["subcategories"] != null
            ? List<Subcategory>.from(
                json["subcategories"].map((x) => Subcategory.fromJson(x)))
            : [],
        subcategoriesNumber: json["subcategoriesNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "subcategories": subcategories != null
            ? List<dynamic>.from(subcategories!.map((x) => x.toJson()))
            : [],
        "subcategoriesNumber": subcategoriesNumber,
      };
}
