import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:flutter/material.dart';

class DiscalimerScreen extends StatefulWidget {
  const DiscalimerScreen({Key key}) : super(key: key);

  @override
  _DiscalimerScreenState createState() => _DiscalimerScreenState();
}

class _DiscalimerScreenState extends State<DiscalimerScreen> {
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppUtils.appBar(false, 'Bmind Hearing Test', context),
      body: Padding(
        padding: EdgeInsets.fromLTRB(width * 0.035, 0, width * 0.035, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.close_outlined,
                            size: 20,
                            color: AppColor.headingTextColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(width * 0.07, 0, width * 0.07, 0),
                      child: Text(
                        'Disclaimer',
                        style: TextStyle(
                          color: AppColor.headingTextColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(width * 0.07, 0, width * 0.07, 0),
                      child: Text(
                        '\u2022 When using ‘be-mind bmind’, be sure to read the disclaimer below.\n\u2022 ‘Bmind bmind’ is not a medical device. This application cannot be used to diagnose disease or injury. If you experience any abnormalities in your ears or hearing, see a doctor.\n\u2022 MINDER takes care to ensure that this application works as well as possible, but does not guarantee its safety, effectiveness or quality.\n\u2022 MINDER shall not be liable for any direct or indirect damages arising out of the use of this application.\n\u2022 Please use this application at your own risk.\n\u2022 About in-app purchases\n- Items sold within the app are only valid with the ID used for purchase.\n- It cannot be transferred or transferred to another account.\n- Thank you for your understanding in advance.',
                        style: TextStyle(
                          height: 1.2,
                          color: AppColor.headingTextColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.09,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
