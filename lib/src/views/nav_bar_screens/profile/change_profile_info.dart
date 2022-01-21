import 'dart:io';

import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/services/database_services.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/custom_button.dart';
import 'package:bmind/src/utils/feild_validator.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChangeInfo extends StatefulWidget {
  const ChangeInfo({Key key}) : super(key: key);

  @override
  _ChangeInfoState createState() => _ChangeInfoState();
}

class _ChangeInfoState extends State<ChangeInfo> {
  double height;
  double width;
  bool isLoading = false;
  final _emailController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File image;
  String url;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = CurrentAppUser.currentUserData.email;
    _nameController.text = CurrentAppUser.currentUserData.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppUtils.appBar(false, 'Profile info change', context),
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
                          Stack(children: [
                            Container(
                                height: 80,
                                width: 80,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: image == null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(700),
                                        child: CachedNetworkImage(
                                          imageUrl: CurrentAppUser
                                              .currentUserData.photo,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        height: 80,
                                        width: 80,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(700),
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
                              Text('Name', style: AppTextStyles.mediumText),
                            ],
                          ),
                          const SizedBox(height: 5),
                          myTextField(
                            controller: _nameController,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            children: [
                              Text('Current email address',
                                  style: AppTextStyles.mediumText),
                            ],
                          ),
                          const SizedBox(height: 5),
                          myTextField(
                              controller: _emailController,
                              readOnly: true,
                              formatter: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r"\s\b|\b\s"))
                              ],
                              validator: FieldValidator.validateEmail),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          // Row(
                          //   children: [
                          //     Text('New email address',
                          //         style: AppTextStyles.mediumText),
                          //   ],
                          // ),
                          // const SizedBox(height: 5),
                          // myTextField(
                          //     controller: _newEmailController,
                          //     formatter: [
                          //       FilteringTextInputFormatter.deny(
                          //           RegExp(r"\s\b|\b\s"))
                          //     ],
                          //     validator: FieldValidator.validateEmail),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            height: 0.05 * height,
                          ),
                          CustomButton.myButton('Save', () async {
                            if (image != null) {
                              setState(
                                () {
                                  isLoading = true;
                                },
                              );
                              url =
                                  await DatabaseServices.uploadUserImage(image);
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(CurrentAppUser.currentUserData.uid)
                                  .update({'photo_url': url});
                              AppUtils.showToast('Profile Picture updated!');

                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            if (CurrentAppUser.currentUserData.name !=
                                _nameController.text) {
                              setState(
                                () {
                                  isLoading = true;
                                },
                              );
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(CurrentAppUser.currentUserData.uid)
                                  .update({'name': _nameController.text});
                              AppUtils.showToast('Account Name updated!');

                              setState(() {
                                isLoading = false;
                              });
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
}
