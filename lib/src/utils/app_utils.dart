import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/views/nav_bar_screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  static appDialogTitle(
    double width,
    double height,
    BuildContext context,
    String content,
    String title,
    String buttonTitle,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(
                width * 0.06, height * 0.03, width * 0.06, height * 0.05),
            title: Text(
              title,
              style: TextStyle(
                color: AppColor.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: Text(
              content,
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: 17,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, width * 0.06, height * 0.04),
                child: GestureDetector(
                  onTap: () {
                    AppNavigator.pop(context);
                  },
                  child: Text(
                    buttonTitle,
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  static appDialog(
    double width,
    double height,
    BuildContext context,
    String content,
    String buttonTitle,
    void Function() onTap,
  ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(
                width * 0.06, height * 0.03, width * 0.06, height * 0.05),
            content: Text(
              content,
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: 17,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, width * 0.06, height * 0.04),
                child: GestureDetector(
                  onTap: () {
                    AppNavigator.pop(ctx);
                    onTap();
                  },
                  child: Text(
                    buttonTitle,
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static appBar(bool isIcon, String text, BuildContext context) {
    return AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColor.whiteColor,
        ),
        actions: isIcon
            ? <Widget>[
                InkWell(
                  onTap: () {
                    AppNavigator.push(context, ChatScreen());
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        child: Image.asset(
                          AppAssetspath.chat,
                          height: 20,
                          width: 20,
                        ),
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
              ]
            : <Widget>[
                SizedBox.shrink(),
              ],
        centerTitle: true,
        title: Text(
          text,
          style: AppTextStyles.headingText.copyWith(color: Colors.white),
        ));
  }

  static appButton(double width, double height, String text,
      {bool dimButton = false}) {
    return Container(
      width: width * 0.8,
      height: height * 0.07,
      decoration: BoxDecoration(
        color: dimButton
            ? AppColor.primaryColor.withOpacity(0.5)
            : AppColor.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Padding itemCard(BuildContext context,
      {String title,
      String imageIcon,
      Widget route,
      Color bgColor,
      Function sets}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: false)
              .push(MaterialPageRoute(builder: (context) => route));
        },
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text(
                  'title',
                  style: AppTextStyles.mediumText.copyWith(fontSize: 14),
                ),
                Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.navigate_next,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
