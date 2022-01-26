import 'dart:io';
import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/services/authentication_service.dart';
import 'package:bmind/src/services/database_services.dart';
import 'package:bmind/src/services/map_services.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/custom_button.dart';
import 'package:bmind/src/utils/feild_validator.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:bmind/src/views/Authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:place_picker/place_picker.dart';

class SellerSignup extends StatefulWidget {
  const SellerSignup({Key key}) : super(key: key);

  @override
  _SellerSignupState createState() => _SellerSignupState();
}

class _SellerSignupState extends State<SellerSignup> {
  double height;
  double width;
  bool isLoading = false;
  String errorText = '';
  LocationResult result;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _recycleLocationController = TextEditingController();
  final _recycleNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _passwordVisible1 = true;
  bool _passwordVisible2 = true;

  final ImagePicker _picker = ImagePicker();
  File image;
  String url;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // isLoading=false;
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
                        height: height * 0.03,
                      ),
                      Text(
                        'Register your Recycle Center',
                        style: AppTextStyles.headingText,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Stack(children: [
                        CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color(0xffA0B0D0),
                            child: image == null
                                ? Icon(
                                    Icons.photo_camera,
                                    color: AppColor.whiteColor,
                                    size: 35,
                                  )
                                : Container(
                                    height: 80,
                                    width: 80,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(700),
                                      child: Image.file(
                                        image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.transparent,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () async {
                                await pickImage();
                                setState(() {});
                              },
                              child: CircleAvatar(
                                radius: 11,
                                backgroundColor: const Color(0xffA0B0D0),
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: AppColor.whiteColor,
                                  child: const Icon(
                                    Icons.edit,
                                    size: 10,
                                    color: Color(0xffA0B0D0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        children: [
                          Text('E-mail', style: AppTextStyles.mediumText),
                        ],
                      ),
                      const SizedBox(height: 5),
                      myTextField(
                        controller: _emailController,
                        formatter: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                        ],
                        label: 'Input E-mail here',
                        validator: (i) {
                          errorText = FieldValidator.validateEmail(i) ?? '';
                          return FieldValidator.validateEmail(i);
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: [
                          Text('Name', style: AppTextStyles.mediumText),
                        ],
                      ),
                      const SizedBox(height: 5),
                      myTextField(
                          controller: _nameController,
                          label: 'Input Name here',
                          validator: FieldValidator.validateField),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: [
                          Text('Password', style: AppTextStyles.mediumText),
                        ],
                      ),
                      const SizedBox(height: 5),
                      myTextField(
                        controller: _passwordController,
                        label: 'Input Password here',
                        obscureText: _passwordVisible1,
                        validator: (i) {
                          errorText = FieldValidator.validatePassword(i) ?? '';
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
                          Text('Confirm Password',
                              style: AppTextStyles.mediumText),
                        ],
                      ),
                      const SizedBox(height: 5),
                      myTextField(
                        controller: _confirmPasswordController,
                        label: 'Input Password here',
                        obscureText: _passwordVisible2,
                        validator: (input) {
                          return FieldValidator.validateConfirmPassword(
                              input, _passwordController.text);
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
                          Text('Phone Number', style: AppTextStyles.mediumText),
                        ],
                      ),
                      const SizedBox(height: 5),
                      myTextField(
                          controller: _phoneController,
                          label: 'Input your phone number',
                          validator: FieldValidator.validateField),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: [
                          Text('Recycling Center Name',
                              style: AppTextStyles.mediumText),
                        ],
                      ),
                      const SizedBox(height: 5),
                      myTextField(
                          controller: _recycleNameController,
                          label: 'Input Recycling Center Name here',
                          validator: FieldValidator.validateField),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: [
                          Text('Recycling Center Location',
                              style: AppTextStyles.mediumText),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            showPlacePicker();
                          },
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              border: Border.all(color: AppColor.fadeColor),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                        'assets/images/pin_location.png',
                                        width: width,
                                        fit: BoxFit.cover))),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      myTextField(
                          controller: _recycleLocationController,
                          label: 'Input Recycling Center Location here',
                          readOnly: true,
                          validator: FieldValidator.validateField),
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
                      CustomButton.myButton('Sign up', () async {
                        if (_formKey.currentState.validate()) {
                          setState(
                            () {
                              isLoading = true;
                            },
                          );
                          url = image == null
                              ? ''
                              : await DatabaseServices.uploadUserImage(image);
                          AuthenticationService service =
                              AuthenticationService(FirebaseAuth.instance);

                          User user = await service.signupWithEmail(
                              email: _emailController.text,
                              password: _passwordController.text,
                              userName: _nameController.text,
                              phoneNumber: _phoneController.text,
                              centerName: _recycleNameController.text,
                              centerLocaton: _recycleLocationController.text,
                              lat: result.latLng.latitude,
                              lng: result.latLng.longitude,
                              photo: url,
                              role: 'seller');

                          if (user != null) {
                            print("User is not null");
                            AppUtils.showToast('User registered!');
                            await service.signOut();
                            AppNavigator.makeFirst(
                                context, const LoginScreen());

                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            print("User is null");
                            setState(() {
                              isLoading = false;
                            });
                          }
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
    );
  }

  Future<File> pickImage() async {
    final img = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720,
        imageQuality: 60);
    if (img == null) return null;

    image = File(img.path);
    return image;
  }

  void showPlacePicker() async {
    result = await MapServices.pickLocation(context, LatLng(32, 72));
    // print("Here we got location of your device :::::: $result");
    if (result != null) {
      setState(() {
        _recycleLocationController.text = result.formattedAddress;
      });
    }
  }
}
