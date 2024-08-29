import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../get_controllers/new_article_get_controller.dart';

class NewArticlePage extends StatelessWidget {
  NewArticlePage({super.key});

  NewArticleGetController getController = Get.put(NewArticleGetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(child: Obx(() {
          return ListView(
            children: [
              ...getController.categories.map((e) {
                return Obx(() {
                  return InkWell(
                    onTap: () {
                      getController.selectedCategory.value = e;
                    },
                    child: Card(
                      elevation: 1.h,
                      color: e == getController.selectedCategory.value
                          ? Colors.blue.shade300
                          : Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 2.h),
                        child: Row(
                          children: [
                            Expanded(child: Text(e.name)),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              }).toList()
            ],
          );
        })),
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.all(1.h),
            child: SizedBox(
              height: 100.h,
              child: Column(
                children: [
                  Focus(
                    focusNode: getController.titleFocusNode,
                    child: TextFormField(
                      controller: getController.titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter article title',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        getController.titleFocusNode.requestFocus();
                      }
                    },
                  ),
                  SizedBox(height: 1.h),
                  Flexible(
                    child: ToolBar(
                      toolBarColor: Colors.white,
                      padding: const EdgeInsets.all(8),
                      iconSize: 25,
                      iconColor: Colors.grey.shade600,
                      activeIconColor: Colors.greenAccent.shade400,
                      controller: getController.quillEditorController,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      customButtons: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () {
                        getController.quillEditorController.requestFocus();
                      },
                      child: QuillHtmlEditor(
                        text:
                            "<h1>Hello</h1>This is a quill html editor example 😊",
                        hintText: 'Type here...',
                        controller: getController.quillEditorController,
                        isEnabled: true,
                        ensureVisible: true,
                        minHeight: 80.h,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        hintTextStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintTextAlign: TextAlign.start,
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        hintTextPadding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                        onFocusChanged: (hasFocus) {
                          if (hasFocus) {
                            getController.quillEditorController.requestFocus();
                          }
                        },
                        onTextChanged: (text) =>
                            debugPrint('widget text change $text'),
                        onEditorCreated: () =>
                            debugPrint('Editor has been loaded'),
                        onEditingComplete: (s) =>
                            debugPrint('Editing completed $s'),
                        onEditorResized: (height) =>
                            debugPrint('Editor resized $height'),
                        onSelectionChanged: (sel) =>
                            debugPrint('${sel.index},${sel.length}'),
                        loadingBuilder: (context) {
                          return Container(); // or your custom loader
                        },

                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.5.h,
                    color: Colors.green,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        getController.saveArticle();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Save'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
