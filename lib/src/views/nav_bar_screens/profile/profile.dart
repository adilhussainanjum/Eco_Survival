import 'dart:io';
import 'dart:typed_data';

import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/services/authentication_service.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/views/Authentication/login.dart';
import 'package:bmind/src/views/nav_bar_screens/profile/change_password.dart';
import 'package:bmind/src/views/nav_bar_screens/profile/change_profile_info.dart';
import 'package:bmind/src/views/nav_bar_screens/profile/Ads/my_ads.dart';
import 'package:bmind/src/views/nav_bar_screens/profile/my_posts.dart';
import 'package:bmind/src/views/nav_bar_screens/profile/saved_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double height;
  double width;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppUtils.appBar(true, 'Profile', context),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 0.9 * width,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.boxBlue,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CurrentAppUser.currentUserData.photo == ''
                              ? Icon(
                                  Icons.account_circle_rounded,
                                  color: Colors.white,
                                  size: 75,
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      CurrentAppUser.currentUserData.photo,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: width * 0.03,
                      ),
                      Text(
                        CurrentAppUser.currentUserData.name,
                        style: TextStyle(
                          color: AppColor.headingTextColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              AppNavigator.push(context, const ChangeInfo());
                            },
                            child: Text('Profile info change',
                                style: AppTextStyles.simpleText),
                          ),
                          Container(
                              width: 1, height: 20, color: AppColor.fadeColor),
                          InkWell(
                            onTap: () {
                              AppNavigator.push(
                                  context, const ChangePassword());
                            },
                            child: Text('Password Change',
                                style: AppTextStyles.simpleText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            myCard('My Posts', AppAssetspath.mypost, () {
                              AppNavigator.push(context, const MyPostScreen());
                            }),
                            const Divider(thickness: 1),
                            myCard('My Favourite', AppAssetspath.download, () {
                              AppNavigator.push(
                                context,
                                FavoritesScreen(),
                              );
                            }, iconData: Icons.favorite, iconColor: Colors.red),
                            CurrentAppUser.currentUserData.role == 'buyer'
                                ? const Divider(thickness: 1)
                                : Container(),
                            CurrentAppUser.currentUserData.role == 'buyer'
                                ? myCard('My Ads', AppAssetspath.request, () {
                                    AppNavigator.push(context, const MyAds());
                                  })
                                : Container()
                          ],
                        ),
                      ),
                    ),

                  SizedBox(
                    height: height * 0.01,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myCard('Log Out', AppAssetspath.logout, () async {
                        AuthenticationService service =
                            AuthenticationService(FirebaseAuth.instance);
                        setState(
                          () {
                            isLoading = true;
                          },
                        );
                        service.signOut();
                        try {
                          await GoogleSignIn().signOut();
                          await GoogleSignIn().disconnect();
                        } catch (e) {}
                        AppNavigator.makeFirstRootTrue(
                            context, const LoginScreen());
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell myCard(String title, String imageIcon, Function onTap,
      {IconData iconData, Color iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: iconData == null
                  ? ClipRRect(
                      child: Image.asset(
                        imageIcon,
                        height: 25,
                        width: 25,
                      ),
                    )
                  : Icon(iconData, color: iconColor)),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyles.mediumText.copyWith(fontSize: 14),
          ),
          const Expanded(child: SizedBox()),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.navigate_next, color: AppColor.fadeColor),
          ),
        ],
      ),
    );
  }
}
