import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/seller%20navbar%20Screens/seller_navbar.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/views/Authentication/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'nav_bar_screens/nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double height;
  @override
  void initState() {
    onClose();
    super.initState();
  }

  onClose() async {
    User user = FirebaseAuth.instance.currentUser;
    await Future.delayed(Duration(seconds: 1));
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> event = await FirebaseFirestore
          .instance
          .collection('users')
          .doc('${user.uid}')
          .get();
      Map<String, dynamic> data = event.data();

      CurrentAppUser.currentUserData.uid = user.uid;
      CurrentAppUser.currentUserData.email = data['email'];
      CurrentAppUser.currentUserData.name = data['name'];
      CurrentAppUser.currentUserData.createdAt = data['created_at'];
      CurrentAppUser.currentUserData.photo = data['photo_url'];
      CurrentAppUser.currentUserData.messages = data['messages'];
      CurrentAppUser.currentUserData.role = data['role'];
      CurrentAppUser.currentUserData.lat = data['lat'];
      CurrentAppUser.currentUserData.lng = data['lng'];
      CurrentAppUser.currentUserData.centerLocation = data['user_location'];
      CurrentAppUser().getCurrentUserData(user.uid).then((value) {
        if (value) {
          if (CurrentAppUser.currentUserData.role == 'buyer') {
            AppNavigator.makeFirst(context, NavBarScreen());
          }
          if (CurrentAppUser.currentUserData.role == 'seller') {
            AppNavigator.makeFirst(context, SellerNavBar());
          }
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      }).onError((error, stackTrace) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.boxBlue,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height * 0.1),
        child: Text('© 2022 minder All rights reserved',
            style: TextStyle(
              fontSize: 15,
              color: AppColor.primaryColor,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              child: Image.asset(
                AppAssetspath.bmind,
                fit: BoxFit.cover,
                height: height * 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
