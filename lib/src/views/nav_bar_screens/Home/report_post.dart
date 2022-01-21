import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/drop_down.dart';
import 'package:bmind/src/utils/feild_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/custom_button.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ReportPost extends StatefulWidget {
  const ReportPost({Key key}) : super(key: key);

  @override
  _ReportPostState createState() => _ReportPostState();
}

class _ReportPostState extends State<ReportPost> {
  double height;
  double width;
  final _guidelineController = TextEditingController();
  final _reportController = TextEditingController();
  String chosenValueDrop;
  bool isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> mylist = [
    'Spam',
    'Inappropriate language',
    'invalid information',
    'Facilitating discrimination harassment and violence'
  ];
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
          appBar: AppUtils.appBar(false, 'Write a new post', context),
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
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Text('Report Inapropriate post',
                                  style: AppTextStyles.mediumText),
                              const Divider(
                                thickness: 1,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Reason for report',
                                    style: AppTextStyles.simpleText,
                                  )
                                ],
                              ),
                              myDropDown(),
                              CustomTextField.myTextField(
                                  controller: _guidelineController,
                                  borderColor: AppColor.dimBorderColor,
                                  maxLines: 12,
                                  label: 'Community guidelines'),
                              CustomTextField.myTextField(
                                  controller: _reportController,
                                  validator: FieldValidator.validateField,
                                  borderColor: AppColor.dimBorderColor,
                                  maxLines: 6,
                                  label: 'Enter report'),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              CustomButton.myButton('Send Report', () async {
                                if (_formKey.currentState.validate()) {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    DocumentReference<Map<String, dynamic>>
                                        docRef = FirebaseFirestore.instance
                                            .collection('reports')
                                            .doc();
                                    String docRefId = docRef.id;
                                    await docRef.set({
                                      'created_at': Timestamp.now(),
                                      'user_id':
                                          CurrentAppUser.currentUserData.uid,
                                      'id': docRefId,
                                      'community_guidelines':
                                          _guidelineController.text,
                                      'report': _reportController.text,
                                      'category': chosenValueDrop
                                    });
                                    setState(() {
                                      isLoading = false;
                                    });
                                    AppUtils.showToast(
                                        'Report Submitted Successfully!!');
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    AppUtils.showToast('Something went Wrong!');
                                  }
                                }
                              }, AppColor.primaryColor, width * 0.7,
                                  height: 35),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ),
          )),
    );
  }

  Widget myDropDown({Color iconColor}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Container(
        child: DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FieldValidator.validateDropDown,
          // iconDisabledColor: iconColor ?? AppColor.primaryColor,
          // iconEnabledColor: iconColor ?? AppColor.primaryColor,
          iconSize: 30,
          value: chosenValueDrop,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: 'Please select category',
            errorText: null,
            errorStyle: TextStyle(height: 0, fontSize: 0),
            hintStyle: TextStyle(
              color: AppColor.fadeColor,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.dimBorderColor,
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
                style: AppTextStyles.simpleText,
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


}
