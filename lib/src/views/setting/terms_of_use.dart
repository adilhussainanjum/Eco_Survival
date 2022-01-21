import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({Key key}) : super(key: key);

  @override
  _TermsConditionsScreenState createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            AppNavigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.headingTextColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Terms of Use',
          style: TextStyle(
            color: AppColor.headingTextColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            width * 0.035, height * 0.02, width * 0.035, height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width,
                height: height * 0.8,
                color: AppColor.whiteColor,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Terms of Use text...',
                        style: TextStyle(
                          color: AppColor.headingTextColor,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
