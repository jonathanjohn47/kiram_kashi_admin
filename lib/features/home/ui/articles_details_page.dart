import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:kiram_kashi_admin/models/article_model.dart';

class ArticlesDetailsPage extends StatelessWidget {
  const ArticlesDetailsPage({super.key, required this.articleModel});

  final ArticleModel articleModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(1.h),
        child: HtmlWidget(articleModel.htmlText),
      )),*/
    );
  }
}
