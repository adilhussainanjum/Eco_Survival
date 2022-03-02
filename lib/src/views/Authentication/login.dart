import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/seller%20navbar%20Screens/seller_navbar.dart';
import 'package:bmind/src/services/authentication_service.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/custom_button.dart';
import 'package:bmind/src/utils/feild_validator.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:bmind/src/views/Authentication/signup.dart';
import 'package:bmind/src/views/nav_bar_screens/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double height;
  double width;
  bool isLoading = false;
  bool validateEmail = true;
  bool validatePass = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    // isLoading = false;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: SizedBox(
                  width: 0.9 * width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),
                      InkWell(
                        onTap: () {
                          AppNavigator.push(context, const SignupScreen());
                        },
                        child: Row(
                          children: [
                            Text(
                              'Don\'t have an account yet?',
                              style: AppTextStyles.underlineText,
                            ),
                          ],
                        ),
                      ),
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
                      myTextField(
                        controller: _emailController,
                        formatter: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                        ],
                        label: 'E-mail',
                        prefixicon: Icons.email_outlined,
                        validator: (i) {
                          errorText = FieldValidator.validateEmail(i) ?? '';
                          return FieldValidator.validateEmail(i);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      myTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: _passwordVisible,
                        prefixicon: Icons.lock_outline,
                        validator: (i) {
                          errorText = FieldValidator.validatePassword(i) ?? '';
                          return FieldValidator.validatePassword(i);
                        },
                        suffixiconbutton: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColor.fadeColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 8.0),
                            child: Text(
                              errorText,
                              style: TextStyle(color: AppColor.errorColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.025 * height,
                      ),
                      CustomButton.myButton('Log in', () async {
                        if (_formKey.currentState.validate()) {
                          AuthenticationService service =
                              AuthenticationService(FirebaseAuth.instance);
                          setState(
                            () {
                              isLoading = true;
                            },
                          );

                          User user = await service
                              .signIn(
                                  email: _emailController.text.toLowerCase(),
                                  password: _passwordController.text)
                              .timeout(Duration(seconds: 20), onTimeout: () {
                            AppUtils.showToast(
                                'Something went wrong, Time out');
                          });

                          if (user != null) {
                            DocumentSnapshot<Map<String, dynamic>> event =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc('${user.uid}')
                                    .get();
                            Map<String, dynamic> data = event.data();

                            CurrentAppUser.currentUserData.uid = user.uid;
                            CurrentAppUser.currentUserData.email =
                                data['email'];
                            CurrentAppUser.currentUserData.name = data['name'];
                            CurrentAppUser.currentUserData.createdAt =
                                data['created_at'];
                            CurrentAppUser.currentUserData.photo =
                                data['photo_url'];
                            CurrentAppUser.currentUserData.messages =
                                data['messages'];
                            CurrentAppUser.currentUserData.role = data['role'];
                            CurrentAppUser.currentUserData.lat = data['lat'];
                            CurrentAppUser.currentUserData.lng = data['lng'];
                            CurrentAppUser.currentUserData.centerLocation =
                                data['user_location'];
                            if (CurrentAppUser.currentUserData.role ==
                                'buyer') {
                              AppUtils.showToast('User logged-in!');
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => NavBarScreen()));

                              setState(() {
                                isLoading = false;
                              });
                            }

                            if (CurrentAppUser.currentUserData.role ==
                                'seller') {
                              AppUtils.showToast('User logged-in!');
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SellerNavBar()));

                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        } else {
                          isLoading = false;
                          setState(() {});
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }, AppColor.primaryColor, width),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                child: Text(
                                  'Forgot ID',
                                  style: AppTextStyles.fadeText,
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              TextButton(
                                child: Text(
                                  'Forgot Password',
                                  style: AppTextStyles.fadeText,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
