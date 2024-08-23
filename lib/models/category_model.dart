// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String name;

  CategoryModel({
    required this.name,
  });

  CategoryModel copyWith({
    String? name,
  }) =>
      CategoryModel(
        name: name ?? this.name,
      );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
