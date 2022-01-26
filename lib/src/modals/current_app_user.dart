import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:bmind/src/modals/app_user.dart';

class CurrentAppUser extends AppUser with ChangeNotifier {
  static final CurrentAppUser _singleton = CurrentAppUser._internal();
  factory CurrentAppUser() => _singleton;
  CurrentAppUser._internal();
  static CurrentAppUser get currentUserData => _singleton;

  Future<bool> getCurrentUserData(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc('$userId')
          .snapshots()
          .listen((event) {
        Map<String, dynamic> data = event.data();

        CurrentAppUser.currentUserData.uid = userId;
        CurrentAppUser.currentUserData.email = data['email'];
        CurrentAppUser.currentUserData.name = data['name'];
        CurrentAppUser.currentUserData.createdAt = data['created_at'];
        CurrentAppUser.currentUserData.photo = data['photo_url'];
        CurrentAppUser.currentUserData.messages = data['messages'];
        CurrentAppUser.currentUserData.role = data['role'];
        CurrentAppUser.currentUserData.lat = data['lat'];
        CurrentAppUser.currentUserData.lng = data['lng'];
        CurrentAppUser.currentUserData.phoneNumber = data['phone_number'];
        CurrentAppUser.currentUserData.centerName =
            data['recycling_center_name'];
        CurrentAppUser.currentUserData.centerLocation = data['user_location'];

        notifyListeners();
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
