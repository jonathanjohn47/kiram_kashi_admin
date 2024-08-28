import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiram_kashi_admin/models/article_model.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../../models/category_model.dart';

class NewArticleGetController extends GetxController {
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  QuillEditorController quillEditorController = QuillEditorController();

  TextEditingController titleController = TextEditingController();

  @override
  void onInit() {
    quillEditorController.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    quillEditorController.onEditorLoaded(() {
      debugPrint('Editor Loaded :)');
    });
    categories.listen((onData) {
      if (onData.isNotEmpty) {
        selectedCategory.value = onData.first;
      }
    });
    loadCategories();
    super.onInit();
  }

  @override
  void dispose() {
    quillEditorController.dispose();
    super.dispose();
  }

  void loadCategories() {
    FirebaseFirestore.instance
        .collection('Categories')
        .orderBy("name")
        .snapshots()
        .listen((onData) {
      categories.value = onData.docs
          .map((e) => CategoryModel.fromJson(jsonDecode(jsonEncode(e.data()))))
          .toList();
    });
  }

  void saveArticle() {
    FirebaseFirestore.instance
        .collection('Categories')
        .where('name', isEqualTo: selectedCategory.value!.name)
        .get()
        .then((onValue) async {
      DocumentSnapshot categoryDoc = onValue.docs.first;
      ArticleModel articleModel = ArticleModel(
          name: titleController.text,
          htmlText: await quillEditorController.getText(),
          category: categoryDoc.reference);
      FirebaseFirestore.instance
          .collection('Articles')
          .add(articleModel.toJson())
          .then((onValue) {
        Get.back();
        Get.snackbar('Success', 'Article saved successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      });
    });
  }
}
