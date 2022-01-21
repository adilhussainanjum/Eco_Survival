import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  String id;
  String title;
  String userId;
  Timestamp createdAt;

  Comments({
    this.id,
    this.title,
    this.userId,
    this.createdAt,
  });

  static Comments fromMap(Map<String, dynamic> map) {
    Comments c = Comments();
    c.id = map['post_id'];
    c.title = map['title'];
    c.userId = map['user_id'];
    c.createdAt = map['created_at'];

    return c;
  }
}
