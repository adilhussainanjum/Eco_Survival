import 'dart:io';

import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/modals/post.dart';
import 'package:bmind/src/services/database_services.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/custom_button.dart';
import 'package:bmind/src/utils/feild_validator.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../nav_bar.dart';

class EditPost extends StatefulWidget {
  EditPost(this.post, {Key key}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
  Post post;
}

class _EditPostState extends State<EditPost> {
  double height;
  double width;
  bool isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File image;
  @override
  void initState() {
    _postController.text = widget.post.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
          appBar: AppUtils.appBar(false, 'Edit your post', context),
          body: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: width * 0.9,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CustomTextField.myTextField(
                                controller: _postController,
                                validator: FieldValidator.validateField,
                                borderColor: AppColor.dimBorderColor,
                                maxLines: 12,
                                label: 'Enter new post'),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          image != null
                              ? Container(
                                  height: 0.13 * height,
                                  width: 0.4 * width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      image,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                )
                              : widget.post.photoUrl != null
                                  ? Container(
                                      height: 0.13 * height,
                                      width: 0.4 * width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.post.photoUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              CustomButton.myButton2('Upload image', () async {
                                await pickImage();
                                setState(() {});
                              }, AppColor.whiteColor, width * 0.4,
                                  icon: Icons.image_outlined,
                                  iconColor: AppColor.headingTextColor,
                                  sideborderColor: AppColor.headingTextColor,
                                  textColor: AppColor.headingTextColor),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Text(
                                'Find out about Community guidelines',
                                style: AppTextStyles.underlineText,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          CustomButton.myButton('Update', () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                String url = '';
                                if (image != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  url = await DatabaseServices.uploadUserImage(
                                      image);
                                  await FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(widget.post.id)
                                      .update({
                                    'photo_url': url,
                                  });
                                  AppUtils.showToast(
                                      'Post Updated Successfully!');
                                  setState(() {
                                    isLoading = false;
                                  });
                                }

                                if (_postController.text != widget.post.post) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(widget.post.id)
                                      .update({
                                    'post': _postController.text,
                                  });
                                  AppUtils.showToast(
                                      'Post Updated Successfully!');
                                  setState(() {
                                    isLoading = false;
                                  });
                                }

                                AppNavigator.makeFirstRootTrue(
                                    context,
                                    NavBarScreen(
                                      initIndex: 0,
                                    ));
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                AppUtils.showToast('Something went Wrong!');
                              }
                            }
                          }, AppColor.primaryColor, width * 0.7, height: 35),
                        ],
                      )),
                ),
              ),
            ),
          )),
    );
  }

  Future<File> pickImage() async {
    final img = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720,
        imageQuality: 40);
    if (img == null) return null;

    image = File(img.path);
    return image;
  }
}
