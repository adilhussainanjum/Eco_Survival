import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/views/setting/distributor_information.dart';
import 'package:bmind/src/views/setting/privacy_policy.dart';
import 'package:bmind/src/views/setting/terms_of_use.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    List<List> settingList = [
      [
        Icons.upgrade_outlined,
        'Send app feedback',
        PrivacyPolicyScreen(),
      ],
      [
        Icons.person_outline_rounded,
        'Privacy Policy',
        PrivacyPolicyScreen(),
      ],
      [
        Icons.description_outlined,
        'Terms of Use',
        TermsConditionsScreen(),
      ],
      [
        Icons.info_outline_rounded,
        'Distributor Information',
        DistributorInformationScreen(),
      ],
    ];
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
          'Setting',
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
                color: AppColor.whiteColor,
                child: Column(
                  children: [
                    ...settingList
                        .map(
                          (settingData) => GestureDetector(
                            onTap: () {
                              AppNavigator.push(context, settingData[2]);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(width * 0.035,
                                  height * 0.025, width * 0.035, height * 0.01),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        settingData[0],
                                        size: 20,
                                        color: AppColor.headingTextColor,
                                      ),
                                      SizedBox(
                                        width: width * 0.025,
                                      ),
                                      Text(
                                        settingData[1],
                                        style: TextStyle(
                                          color: AppColor.headingTextColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 17,
                                    color: AppColor.headingTextColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.025, right: width * 0.025),
                      child: Divider(
                        color: AppColor.headingTextColor,
                      ),
                    ),
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
