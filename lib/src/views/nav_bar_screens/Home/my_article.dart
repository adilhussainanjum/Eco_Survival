import 'package:bmind/src/modals/artical.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MyArticle extends StatefulWidget {
  const MyArticle(this.article, {Key key}) : super(key: key);

  @override
  _MyArticleState createState() => _MyArticleState();
  final Article article;
}

class _MyArticleState extends State<MyArticle> {
  double height;
  double width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppUtils.appBar(false, 'Article', context),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: width * 0.95,
              child: Column(
                children: [
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Html(data: widget.article.article),
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}
