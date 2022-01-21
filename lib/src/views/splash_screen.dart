import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/views/Authentication/login.dart';
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
      CurrentAppUser().getCurrentUserData(user.uid).then((value) {
        if (value) {
          AppNavigator.makeFirst(context, NavBarScreen());
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
