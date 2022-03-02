import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/services/authentication_service.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/views/Authentication/buyer.dart';
import 'package:bmind/src/views/Authentication/seller.dart';
import 'package:bmind/src/views/nav_bar_screens/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  double height;
  double width;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: InkWell(
          onTap: () {
            AppNavigator.push(context, SellerSignup());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                child: Image.asset(
                  AppAssetspath.recycle,
                  fit: BoxFit.cover,
                  height: height * 0.03,
                  width: height * 0.03,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Register As Recycle Center.',
                style:
                    TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 0.9 * width,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    ClipRRect(
                      child: Image.asset(
                        AppAssetspath.bmind,
                        fit: BoxFit.cover,
                        height: height * 0.1,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Row(
                      children: [
                        Text(
                          'Sign up',
                          style: AppTextStyles.headingText,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'First time Registering an account?',
                          style: AppTextStyles.simpleText,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Please Sign in using the applications below.',
                          style: AppTextStyles.simpleText,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    InkWell(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          User user =
                              await AuthenticationService(FirebaseAuth.instance)
                                  .signInWithGoogle();
                          if (user != null) {
                            AppNavigator.makeFirst(
                                context,
                                NavBarScreen(
                                  initIndex: 0,
                                ));
                          } else {
                            AppUtils.showToast('Login failed!');
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child:
                            myContainer(AppAssetspath.google, 'Google Login.')),
                    InkWell(
                      onTap: () {
                        AppNavigator.push(context, BuyerSingnup());
                      },
                      child: myContainer(
                          AppAssetspath.mail, 'Register with email.'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Padding myContainer(String name, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        height: height * 0.06,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColor.fadeColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              child: Image.asset(
                name,
                fit: BoxFit.cover,
                height: height * 0.06,
                width: height * 0.06,
              ),
            ),
            Text(
              text,
              style: AppTextStyles.simpleText,
            ),
            SizedBox(
              height: height * 0.06,
              width: height * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}
