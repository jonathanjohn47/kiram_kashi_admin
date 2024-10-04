// To parse this JSON data, do
//
//     final articleModel = articleModelFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ArticleModel articleModelFromJson(String str) =>
    ArticleModel.fromJson(json.decode(str));

String articleModelToJson(ArticleModel data) => json.encode(data.toJson());

class ArticleModel {
  String name;
  String htmlText;
  DocumentReference category;
  int index;

  ArticleModel({
    required this.name,
    required this.htmlText,
    required this.category,
    required this.index,
  });

  ArticleModel copyWith({
    String? name,
    String? htmlText,
    DocumentReference? category,
    int? index,
  }) =>
      ArticleModel(
        name: name ?? this.name,
        htmlText: htmlText ?? this.htmlText,
        category: category ?? this.category,
        index: index ?? this.index,
      );

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
      name: json["name"],
      htmlText: json["htmlText"],
      category: FirebaseFirestore.instance.doc(json["category"].path),
      index: json["index"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "htmlText": htmlText,
        "category": category,
        "index": index
      };
}
