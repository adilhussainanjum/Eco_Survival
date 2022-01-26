import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/modals/ad.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/views/nav_bar_screens/profile/Ads/ad_detail.dart';
import 'package:bmind/src/views/nav_bar_screens/profile/Ads/new_ad.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAds extends StatefulWidget {
  const MyAds({Key key}) : super(key: key);

  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  double height;
  double width;

  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppUtils.appBar(false, 'My Ads', context),
      floatingActionButton: InkWell(
        onTap: () {
          AppNavigator.push(context, const NewAd());
        },
        child: CircleAvatar(
          backgroundColor: AppColor.navBarGrey,
          child: Icon(
            Icons.add,
            color: AppColor.headingTextColor,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('ads')
              .where('user_id', isEqualTo: CurrentAppUser.currentUserData.uid)
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
            List<Ad> ads = [];
            docList.forEach((element) {
              Ad ad = Ad.fromMap(element.data());
              ads.add(ad);
            });
            return SizedBox(
              width: width,
              child: ads.isEmpty
                  ? Center(child: Text('No Ads yet'))
                  : Wrap(
                      alignment: WrapAlignment.center,
                      children: ads
                          .map(
                            (e) => SizedBox(
                              width: width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.transparent),
                                  child: Card(
                                    child: InkWell(
                                      onTap: () {
                                        AppNavigator.push(
                                            context, AdDetails(ad: e));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 120,
                                            width: width * 0.5 - 20,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              child: CachedNetworkImage(
                                                  imageUrl: e.photos[0],
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 2, right: 4),
                                            child: Row(
                                              children: [
                                                Text(e.title,
                                                    style: AppTextStyles
                                                        .simpleText),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 2, right: 4),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  child: e.status == true
                                                      ? const Icon(
                                                          Icons.done_all,
                                                          color: Colors.green,
                                                          size: 14)
                                                      : Icon(
                                                          Icons
                                                              .fiber_manual_record,
                                                          color: AppColor
                                                              .errorColor,
                                                          size: 14),
                                                ),
                                                e.status == true
                                                    ? Text('Sold',
                                                        style: AppTextStyles
                                                            .simpleText
                                                            .copyWith(
                                                                fontSize: 12))
                                                    : Text('Unsold',
                                                        style: AppTextStyles
                                                            .simpleText
                                                            .copyWith(
                                                                fontSize: 12)),
                                                const Expanded(
                                                    child: SizedBox()),
                                                Text(e.price,
                                                    style: AppTextStyles
                                                        .simpleText
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                Text('(INR)',
                                                    style: AppTextStyles
                                                        .simpleText
                                                        .copyWith(fontSize: 12))
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1,
                                            endIndent: 10,
                                            indent: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 2, right: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    DateFormat('yMMMd').format(
                                                        e.createdAt.toDate()),
                                                    style: AppTextStyles
                                                        .simpleText
                                                        .copyWith(
                                                            fontSize: 10)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList()),
            );
          }),
    );
  }
}
