import 'dart:io';
import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/custom_button.dart';
import 'package:bmind/src/utils/feild_validator.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:bmind/src/views/nav_bar_screens/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NewAd extends StatefulWidget {
  const NewAd({Key key}) : super(key: key);

  @override
  _NewAdState createState() => _NewAdState();
}

class _NewAdState extends State<NewAd> {
  double height;
  double width;
  String chosenValueDrop;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> _images = [];
  List<String> mylist = ['Plastic', 'Metal', 'Others'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppUtils.appBar(false, 'Post a new Ad', context),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: width * 0.9,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Text('Product Name', style: AppTextStyles.mediumText),
                      ],
                    ),
                    const SizedBox(height: 5),
                    myTextField(
                        controller: _titleController,
                        label: 'Enter your product name',
                        validator: FieldValidator.validateField),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Text('Product Description',
                            style: AppTextStyles.mediumText),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CustomTextField.myTextField(
                        controller: _desController,
                        maxLines: 3,
                        label: 'Enter your product description',
                        validator: FieldValidator.validateField),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Text('Product Price', style: AppTextStyles.mediumText),
                      ],
                    ),
                    const SizedBox(height: 5),
                    myTextField(
                        controller: _priceController,
                        label: 'Enter your product price',
                        keyboardType: TextInputType.phone,
                        validator: FieldValidator.validateField),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Text('Product Category',
                            style: AppTextStyles.mediumText),
                      ],
                    ),
                    const SizedBox(height: 5),
                    myDropDown(),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final List<XFile> images = await _picker.pickMultiImage(
                            maxHeight: 720, maxWidth: 720, imageQuality: 60);
                        if (images.isNotEmpty) {
                          if (images.length > 5) {
                            _images = images
                                .sublist(0, 5)
                                .map((e) => File(e.path))
                                .toList();
                            setState(() {});
                          } else {
                            _images = images.map((e) => File(e.path)).toList();
                            setState(() {});
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: AppColor.primaryColor),
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 24.0,
                      ),
                      label: Text(
                        'Pick Some Images',
                        style: AppTextStyles.headingText
                            .copyWith(color: AppColor.whiteColor),
                      ),
                    ),
                    Wrap(
                        children: _images
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        child: Image.file(
                                          e,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ))
                            .toList()),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    CustomButton.myButton('Post Ad', () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          List<dynamic> imgUrls = (await uploadImage(_images));
                          if (imgUrls.isNotEmpty) {
                            await _uploadToFireStore(imgUrls);
                            AppUtils.showToast('Ad posted Successfully!');
                            AppNavigator.makeFirstRootTrue(
                                context,
                                NavBarScreen(
                                  initIndex: 2,
                                ));

                            setState(() {
                              isLoading = false;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          AppUtils.showToast('Something went Wrong!');
                        }
                      }
                    }, AppColor.primaryColor, width * 0.7, height: 35),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myDropDown({Color iconColor}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Container(
        child: DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FieldValidator.validateDropDown,
          iconSize: 30,
          value: chosenValueDrop,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: 'Please select category',
            errorText: null,
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            hintStyle: TextStyle(
              color: AppColor.fadeColor,
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.fadeColor,
                width: 1.0,
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
          ),
          style: const TextStyle(color: Colors.white),
          items: mylist.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: AppTextStyles.simpleText.copyWith(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (value) {
            chosenValueDrop = value;
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<List> uploadImage(List<File> img) async {
    List<String> urls = [];
    try {
      for (var item in img) {
        TaskSnapshot task = await FirebaseStorage.instance
            .ref('images/${Timestamp.now().toString()}.png')
            .putFile(item);
        String url = await task.ref.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } on FirebaseException catch (e) {
      AppUtils.showToast('Something went wrong');
      return urls;
    }
  }

  Future<void> _uploadToFireStore(List urls) async {
    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('ads').doc();
    String docRefId = docRef.id;
    await docRef.set({
      'created_at': Timestamp.now(),
      'user_id': CurrentAppUser.currentUserData.uid,
      'ad_id': docRefId,
      'title': _titleController.text,
      'description': _desController.text,
      'price': _priceController.text,
      'category': chosenValueDrop,
      'photo_url': urls,
      'status': false
    });
  }
}
