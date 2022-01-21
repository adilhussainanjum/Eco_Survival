import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/modals/app_user.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/views/nav_bar_screens/chat/chatting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:map_launcher/map_launcher.dart';

class RecyclingCenter extends StatefulWidget {
  const RecyclingCenter({Key key}) : super(key: key);

  @override
  _RecyclingCenterState createState() => _RecyclingCenterState();
}

class _RecyclingCenterState extends State<RecyclingCenter> {
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Recycling Centers',
            style: AppTextStyles.headingText.copyWith(color: Colors.white),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              width * 0.04, height * 0.02, width * 0.04, height * 0.03),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.02, 0, width * 0.02, height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Nearest available shops',
                          style: AppTextStyles.mediumText
                              .copyWith(color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'seller')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Text('Something went wrong!');
                      }
                      if (!snapshot.hasData) {
                        return const Text("No Data Found");
                      }

                      List<QueryDocumentSnapshot> docList = snapshot.data.docs;
                      List<AppUser> users = [];
                      docList.forEach((element) {
                        AppUser u = AppUser.fromMap(element.data());
                        users.add(u);
                      });

                      return Column(
                          children: users
                              .map(
                                (e) => Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: myCard(e, () {}),
                                )),
                              )
                              .toList());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell myCard(
    AppUser user,
    Function onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    child: Image.asset(
                      AppAssetspath.shops,
                      height: 17,
                      width: 20,
                    ),
                  )),
              const SizedBox(width: 8),
              Text('${user.centerName}',
                  style: AppTextStyles.mediumText.copyWith(fontSize: 14)),
            ],
          ),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    child: Image.asset(
                      AppAssetspath.place,
                      height: 20,
                      width: 20,
                    ),
                  )),
              const SizedBox(width: 8),
              FittedBox(
                child: Text(
                  '${user.centerLocation}',
                  style: AppTextStyles.simpleText.copyWith(fontSize: 14),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Icon(
              //     Icons.navigate_next,
              //     color: AppColor.fadeColor,
              //     size: 30,
              //   ),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChattingScreen(
                          appUser: user,
                          currentUser: CurrentAppUser.currentUserData)));
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
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  final availableMaps = await MapLauncher.installedMaps;

                  await availableMaps.first.showMarker(
                    coords: Coords(user.lat, user.lng),
                    title: user.centerName,
                    description: user.centerLocation,
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      child: Image.asset(
                        AppAssetspath.directions,
                        height: 20,
                        width: 20,
                      ),
                    )),
              ),
              SizedBox(width: width * 0.1),
            ],
          )
        ],
      ),
    );
  }
}
