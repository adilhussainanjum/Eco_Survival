import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/custom_button.dart';
import 'package:bmind/src/utils/feild_validator.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  double height;
  double width;
  bool isLoading = false;
  final _currentPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _passwordVisible1 = true;
  bool _passwordVisible2 = true;
  bool _passwordVisible3 = true;
  String errorText = '';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppUtils.appBar(false, 'Profile Password change', context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: SizedBox(
                  width: 0.95 * width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              Text('Current password',
                                  style: AppTextStyles.mediumText),
                            ],
                          ),
                          const SizedBox(height: 5),
                          myTextField(
                            controller: _currentPasswordController,
                            obscureText: _passwordVisible1,
                            label: 'Enter current password',
                            validator: (i) {
                              errorText =
                                  FieldValidator.validatePassword(i) ?? '';
                              return FieldValidator.validatePassword(i);
                            },
                            suffixiconbutton: IconButton(
                              icon: Icon(
                                _passwordVisible1
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColor.fadeColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible1 = !_passwordVisible1;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            children: [
                              Text('New password',
                                  style: AppTextStyles.mediumText),
                            ],
                          ),
                          const SizedBox(height: 5),
                          myTextField(
                            label: 'Enter new password',
                            controller: _newPasswordController,
                            obscureText: _passwordVisible2,
                            validator: (i) {
                              errorText =
                                  FieldValidator.validatePassword(i) ?? '';
                              return FieldValidator.validatePassword(i);
                            },
                            suffixiconbutton: IconButton(
                              icon: Icon(
                                _passwordVisible2
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColor.fadeColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible2 = !_passwordVisible2;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            children: [
                              Text('New confirm password',
                                  style: AppTextStyles.mediumText),
                            ],
                          ),
                          const SizedBox(height: 5),
                          myTextField(
                            label: 'Enter new password again',
                            controller: _confirmPasswordController,
                            obscureText: _passwordVisible3,
                            validator: (input) {
                              return FieldValidator.validateConfirmPassword(
                                  input, _newPasswordController.text);
                            },
                            suffixiconbutton: IconButton(
                              icon: Icon(
                                _passwordVisible3
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColor.fadeColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible3 = !_passwordVisible3;
                                });
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 10.0, 0.0, 8.0),
                                child: Text(
                                  errorText,
                                  style: TextStyle(color: AppColor.errorColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            height: 0.05 * height,
                          ),
                          CustomButton.myButton('Save', () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: CurrentAppUser
                                                .currentUserData.email,
                                            password: _currentPasswordController
                                                .text);

                                if (userCredential != null) {
                                  await FirebaseAuth.instance.currentUser
                                      .updatePassword(
                                          _newPasswordController.text);
                                  AppNavigator.pop(context);
                                  AppUtils.showToast(
                                      'Your password has been changed Successfully!');
                                }
                              } catch (e) {
                                AppUtils.showToast(
                                    'Your Current password is Incorrect!');
                              }

                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {});
                            }
                          }, AppColor.primaryColor, width * 0.75),
                        ],
                      ),
                    ),
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
