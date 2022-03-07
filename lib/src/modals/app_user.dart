import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String uid;
  String email;
  String name;
  Timestamp createdAt;
  String fcm;
  String photo;
  String phoneNumber;
  String centerName;
  String centerLocation;
  double lat;
  double lng;
  String role;
  List<dynamic> messages = [];

  AppUser(
      {this.uid,
      this.email,
      this.name,
      this.createdAt,
      this.fcm,
      this.photo,
      this.phoneNumber,
      this.centerLocation,
      this.centerName,
      this.lat,
      this.messages,
      this.lng,
      this.role});

  static AppUser fromMap(Map<String, dynamic> map) {
    AppUser appUser = AppUser();
    appUser.uid = map['user_id'];
    appUser.email = map['email'];
    appUser.name = map['name'];
    appUser.photo = map['photo_url'];
    appUser.createdAt = map['created_at'];
    appUser.fcm = map['fcm'];
    appUser.phoneNumber = map['phone_number'];
    appUser.centerName = map['recycling_center_name'];
    appUser.centerLocation = map['user_location'];
    appUser.lat = map['lat'];
    appUser.lng = map['lng'];
    appUser.role = map['role'];
    appUser.messages = map['messages'];
    return appUser;
  }

  static Map<String, dynamic> toMapseller(AppUser user) {
    return {
      'user_id': user.uid,
      'email': user.email,
      'name': user.name,
      'created_at': user.createdAt,
      'fcm': user.fcm,
      'photo_url': user.photo,
      'phone_number': user.phoneNumber,
      'recycling_center_name': user.centerName,
      'user_location': user.centerLocation,
      'lng': user.lng,
      'lat': user.lat,
      'role': user.role
    };
  }

  static Map<String, dynamic> toMapbuyer(AppUser user) {
    return {
      'user_id': user.uid,
      'email': user.email,
      'name': user.name,
      'created_at': user.createdAt,
      'fcm': user.fcm,
      'photo_url': user.photo,
      'phone_number': user.phoneNumber,
      'user_location': user.centerLocation,
      'lng': user.lng,
      'lat': user.lat,
      'role': user.role
    };
  }

  static Future<AppUser> getAppUserWithId(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc('$id').get();
    return AppUser.fromMap(doc.data() as Map<String, dynamic>);
  }
}
