import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String id;
  Timestamp createdAt;
  String userId;
  String article;

  Article({
    this.id,
    this.article,
    this.userId,
    this.createdAt,
  });

  static Article fromMap(Map<String, dynamic> map) {
    Article a = Article();
    a.id = map['article_id'];
    a.article = map['article'];
    a.userId = map['user_id'];
    a.createdAt = map['created_at'];

    return a;
  }
}
