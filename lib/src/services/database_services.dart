import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:bmind/src/modals/app_user.dart';

class DatabaseServices {
  static Future<void> uploadNewBuyerData(AppUser appuser) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(appuser.uid);
    await docRef.set(AppUser.toMapbuyer(appuser));
  }
   static Future<void> uploadNewSellerData(AppUser appuser) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(appuser.uid);
    await docRef.set(AppUser.toMapseller(appuser));
  }

  static Future<String> uploadUserImage(File image) async {
    try {
      TaskSnapshot task = await FirebaseStorage.instance
          .ref('images/${Timestamp.now().toString()}.png')
          .putFile(image);
      String url = await task.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
        msg: 'Error ${e.code}: ${e.message}',
        gravity: ToastGravity.BOTTOM,
      );
      return null;
    }
  }
}
