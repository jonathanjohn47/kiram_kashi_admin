import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiram_kashi_admin/models/article_model.dart';
import 'package:kiram_kashi_admin/models/category_model.dart';

class HomePageGetController extends GetxController {
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  RxList<ArticleModel> allArticlesInSelectedCategory = <ArticleModel>[].obs;

  @override
  void onInit() {
    selectedCategory.listen((onData) {
      loadArticles();
    });
    categories.listen((onData) {
      if (onData.isNotEmpty) {
        selectedCategory.value = onData.first;
      }
    });
    Future.delayed(Duration(milliseconds: 200), () {
      loadCategories();
    });

    //deleteDuplicateArticlesFromFirebase();
    super.onInit();
  }

  void loadArticles() {
    if (selectedCategory.value != null) {
      FirebaseFirestore.instance
          .collection('Categories')
          .where('name', isEqualTo: selectedCategory.value!.name)
          .snapshots()
          .listen((onValue) {
        DocumentSnapshot categoryDoc = onValue.docs.first;
        DocumentReference categoryReference = categoryDoc.reference;
        FirebaseFirestore.instance
            .collection('Articles')
            .where("category", isEqualTo: categoryDoc.reference)
            .snapshots()
            .listen((onData) {
          allArticlesInSelectedCategory.value =
              onData.docs.map((e) => ArticleModel.fromJson(e.data())).toList();
        });
      });
    }
  }

  void loadCategories() {
    FirebaseFirestore.instance
        .collection('Categories')
        .orderBy("id", descending: false)
        .snapshots()
        .listen((onData) {
      categories.value = onData.docs
          .map((e) => CategoryModel.fromJson(jsonDecode(jsonEncode(e.data()))))
          .toList();
    });
  }

  void deleteArticle(ArticleModel article) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Article"),
            content: Text("Are you sure you want to delete this article?"),
            actions: [
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Articles')
                        .where('name', isEqualTo: article.name)
                        .get()
                        .then((querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        querySnapshot.docs.first.reference.delete();
                      }
                      Get.back();
                    });
                  },
                  child: Text("Yes")),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("No")),
            ],
          );
        });
  }

  void deleteCategory(CategoryModel e) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Category"),
            content: Text(
                "All the articles in this category will be deleted. This action cannot be undone. Are you sure you want to delete this category?"),
            actions: [
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Categories')
                        .where('name', isEqualTo: e.name)
                        .get()
                        .then((categoryQuerySnapshot) {
                      if (categoryQuerySnapshot.docs.isNotEmpty) {
                        DocumentReference categoryRef =
                            categoryQuerySnapshot.docs.first.reference;

                        FirebaseFirestore.instance
                            .collection('Articles')
                            .where('category', isEqualTo: categoryRef)
                            .get()
                            .then((articleQuerySnapshot) {
                          for (var doc in articleQuerySnapshot.docs) {
                            doc.reference.delete();
                          }
                          categoryRef.delete().then((_) {
                            Get.back();
                          });
                        });
                      }
                    });
                  },
                  child: Text("Yes")),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("No")),
            ],
          );
        });
  }

  void arrangeArticles() {
    Future.forEach(articleNamesAndTheirIndex.keys, (article) {
      FirebaseFirestore.instance.collection("Articles").get().then((onValue) {
        Future.forEach(onValue.docs, (doc) {
          if (doc['name'].toLowerCase().contains(article.toLowerCase())) {
            doc.reference.update({"index": articleNamesAndTheirIndex[article]});
          }
        });
      });
    });
  }

  void deleteDuplicateArticlesFromFirebase() {
    FirebaseFirestore.instance.collection('Articles').get().then((onValue) {
      Future.forEach(onValue.docs, (doc1) {
        Future.forEach(onValue.docs, (doc2) {
          if (doc1.reference != doc2.reference) {
            if (doc1['name']
                .toLowerCase()
                .contains(doc2['name'].toLowerCase())) {
              doc2.reference.delete();
            }
          }
        });
      });
    });
  }
}

Map<String, int> articleNamesAndTheirIndex = {
  'Sa': 1,
  'Mulberry t': 2,
  'inp': 3,
  'Major mulberry i': 1,
  'Major mulberry d': 2,
  'Integrated P': 3,
  'Rearing ': 1,
  'Env': 2,
  'Qua': 3,
  'Disi': 4,
  'Mou': 5,
  'Ha': 6,
  'Dr': 7,
  'Major S': 1,
  'Integrated m': 2,
  'Mai': 3
};
