import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';

import '../get_controllers/new_category_get_controller.dart';

class NewCategoryPage extends StatelessWidget {
  NewCategoryPage({super.key});

  NewCategoryGetController getController = Get.put(NewCategoryGetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: getController.categoryNameController,
            decoration: InputDecoration(
                labelText: 'Category Name', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 2.h,
          ),
          ElevatedButton(
              onPressed: () {
                getController.saveCategory();
              },
              child: Text('Save'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ))
        ],
      ),
    ));
  }
}
