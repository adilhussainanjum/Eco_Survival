import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  String id;
  String title;
  String description;
  String category;
  String price;
  String userId;
  Timestamp createdAt;
  bool status;
  double lat;
  double lng;
  List<dynamic> photos;
  double distance;

  Ad(
      {this.id,
      this.title,
      this.description,
      this.category,
      this.price,
      this.userId,
      this.createdAt,
      this.photos,
      this.status,
      this.lat,
      this.lng});

  static Ad fromMap(Map<String, dynamic> map) {
    Ad ad = Ad();
    ad.id = map['ad_id'];
    ad.title = map['title'];
    ad.description = map['description'];
    ad.category = map['category'];
    ad.price = map['price'];
    ad.userId = map['user_id'];
    ad.createdAt = map['created_at'];
    ad.photos = map['photo_url'];
    ad.status = map['status'];
    ad.lat = map['lat'];
    ad.lng = map['lng'];
    return ad;
  }
}
