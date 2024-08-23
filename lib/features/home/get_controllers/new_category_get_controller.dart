import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiram_kashi_admin/models/category_model.dart';

class NewCategoryGetController extends GetxController {
  TextEditingController categoryNameController = TextEditingController();

  void saveCategory() {
    if (categoryNameController.text.trim().isNotEmpty) {
      CategoryModel categoryModel =
          CategoryModel(name: categoryNameController.text);

      FirebaseFirestore.instance
          .collection('Categories')
          .add(categoryModel.toJson())
          .then((value) {
        Get.back();
        Get.snackbar('Success', 'Category added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      });
    }
  }
}
