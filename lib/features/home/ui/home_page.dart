import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:kiram_kashi_admin/models/article_model.dart';

import '../../new_article/ui/new_article_page.dart';
import '../get_controllers/home_page_get_controller.dart';
import 'new_category_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomePageGetController getController = Get.put(HomePageGetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: [
            Expanded(
                child: Stack(
              children: [
                Obx(() {
                  return ListView(
                    children: [
                      ...getController.categories.map((e) {
                        return Obx(() {
                          return InkWell(
                            onTap: () {
                              getController.selectedCategory.value = e;
                            },
                            onSecondaryTapDown: (context) {
                              getController.deleteCategory(e);
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
                }),
                Positioned(
                  bottom: 2.h,
                  right: 2.h,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Get.to(() => NewCategoryPage());
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            )),
            Container(
              height: 100.h,
              width: 2,
              color: Colors.green.shade100,
            ),
            Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Obx(() {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: (context, index) {
                          ArticleModel article =
                              getController.allArticlesInSelectedCategory[index];
                          return Card(
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    article.name,
                                    style: TextStyle(
                                        fontSize: 4.h,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                      onPressed: () {
                                        getController.deleteArticle(article);
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      )),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount:
                            getController.allArticlesInSelectedCategory.length,
                      );
                    }),
                    Positioned(
                      bottom: 2.h,
                      right: 2.h,
                      child: FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          Get.to(() => NewArticlePage());
                        },
                        child: Icon(Icons.add),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
