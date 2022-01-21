import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String post;
  String userId;
  Timestamp createdAt;
  String photoUrl;
  List<dynamic> likes;
  bool show;

  Post(
      {this.id,
      this.post,
      this.userId,
      this.createdAt,
      this.photoUrl,
      this.likes});

  static Post fromMap(Map<String, dynamic> map) {
    Post p = Post();
    p.id = map['post_id'].toString();
    p.post = map['post'];
    p.userId = map['user_id'];
    p.photoUrl = map['photo_url'];
    p.createdAt = map['created_at'];
    p.likes = map['likes']??[];

    return p;
  }
}
