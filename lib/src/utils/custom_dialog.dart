import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom_button.dart';

class CustomDialog {
  static customDialog(
    BuildContext context,
    double width,
    double height, {
    TextEditingController title,
    TextEditingController description,
    TextEditingController reward,
    TextEditingController coin,
    TextEditingController avgTime,
    TextEditingController age,
    TextEditingController result,
  }) async {
    await showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.02),
                    Center(
                        child: Text(
                      'Create a New Survay',
                      style: AppTextStyles.headingText,
                    )),
                    dialogCard('Title', title),
                    dialogCard('Description', description),
                    dialogCard('Reward', reward),
                    dialogCard('Coins', coin),
                    dialogCard('Average Time', avgTime),
                    dialogCard('Age', age),
                    dialogCard('ResultCheck', result),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButton.myButton2('Save', () {},
                              AppColor.primaryColor, width * 0.27),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Padding dialogCard(
    String title,
    TextEditingController textController,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          myTextField(
            controller: textController,
          ),
        ],
      ),
    );
  }

  static Future<void> showConfirmDeleteAlertPopup(
      BuildContext context1, double width,
      {String id}) async {
    return showDialog<void>(
      context: context1,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.185,
                    ),
                    Text(
                      'Delete Ad',
                      style: AppTextStyles.mediumText
                          .copyWith(color: Colors.black),
                    ),
                    const Expanded(child: SizedBox()),
                    TextButton(
                      child: Icon(
                        Icons.close,
                        size: 18,
                        // color: AppColor.greyiconColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Are you sure you want to delete this ad?',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          actions: [
            // const Divider(
            //   thickness: 2,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton.myButton(
                  'Cancel',
                  () {
                    Navigator.pop(context);
                  },
                  Colors.white,
                  width * 0.2,
                  sideborderColor: AppColor.fadeColor,
                  textColor: AppColor.fadeColor,
                ),
                CustomButton.myButton('Delete', () async {
                  await FirebaseFirestore.instance
                      .collection('ads')
                      .doc(id)
                      .delete();
                  Fluttertoast.showToast(
                    msg: 'The Post has been deleted successfully',
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.pop(context);
                  Navigator.pop(context1);
                }, Colors.red.withOpacity(0.8), width * 0.2,
                    sideborderColor: Color(0xffDF7878)),
              ],
            ),
          ],
        );
      },
    );
  }
}
