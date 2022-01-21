import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/modals/ad.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/custom_button.dart';
import 'package:bmind/src/utils/custom_dialog.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/views/nav_bar_screens/profile/Ads/edit_ad.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdDetails extends StatefulWidget {
  const AdDetails({this.ad, Key key}) : super(key: key);

  @override
  _AdDetailsState createState() => _AdDetailsState();
  final Ad ad;
}

class _AdDetailsState extends State<AdDetails> {
  double height;
  double width;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      enlargeCenterPage: true, viewportFraction: 1),
                  items: widget.ad.photos.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            ClipRRect(
                              child: SizedBox(
                                width: width,
                                child: CachedNetworkImage(
                                  imageUrl: i,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Card(
                                      color: AppColor.greyColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                            '${widget.ad.photos.indexOf(i) + 1} ' +
                                                '/ ' +
                                                '${widget.ad.photos.length}',
                                            style: TextStyle(
                                                color: AppColor.whiteColor)),
                                      ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: () {
                                      AppNavigator.pop(context);
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        color: AppColor.leftContainer,
                                        child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.arrow_back,
                                            ))),
                                  )),
                            )
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
                Center(
                  child: SizedBox(
                    width: width * 0.95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(' Status:', style: AppTextStyles.smallText),
                            Switch(
                                value: widget.ad.status,
                                onChanged: (bool value) {
                                  widget.ad.status == true ? unsold() : sold();
                                }),
                            const Expanded(child: SizedBox()),
                            myCard(AppAssetspath.delete, () {
                              CustomDialog.showConfirmDeleteAlertPopup(
                                  context, width,
                                  id: widget.ad.id);
                            }),
                            myCard(AppAssetspath.edit, () {
                              AppNavigator.push(context, EditAd(widget.ad));
                            }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Title:', style: AppTextStyles.mediumText),
                              Text(widget.ad.title,
                                  style: AppTextStyles.simpleText),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.ad.description,
                                style: AppTextStyles.simpleText,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Price:', style: AppTextStyles.mediumText),
                              Text(widget.ad.price + '(INR)',
                                  style: AppTextStyles.simpleText),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Status:', style: AppTextStyles.mediumText),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                child: widget.ad.status == true
                                    ? const Icon(Icons.done_all,
                                        color: Colors.green, size: 18)
                                    : Icon(Icons.fiber_manual_record,
                                        color: AppColor.errorColor, size: 18),
                              ),
                              const SizedBox(width: 5),
                              widget.ad.status == true
                                  ? Text('Sold',
                                      style: AppTextStyles.simpleText)
                                  : Text('Unsold',
                                      style: AppTextStyles.simpleText)
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Category:',
                                  style: AppTextStyles.mediumText),
                              Text(widget.ad.category,
                                  style: AppTextStyles.simpleText),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Posted on:',
                                  style: AppTextStyles.mediumText),
                              Text(
                                  DateFormat('yMMMd')
                                      .format(widget.ad.createdAt.toDate()),
                                  style: AppTextStyles.simpleText),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  sold() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('ads')
          .doc(widget.ad.id)
          .update({'status': true});
      widget.ad.status = true;
      setState(() {
        isLoading = false;
      });
      AppUtils.showToast('Marked as Sold');
      // AppNavigator.pop(context);
    } catch (e) {
      AppUtils.showToast('$e');
    }
  }

  unsold() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('ads')
          .doc(widget.ad.id)
          .update({'status': false});
      widget.ad.status = false;
      setState(() {
        isLoading = false;
      });
      AppUtils.showToast('Marked as unold');
    } catch (e) {
      AppUtils.showToast('$e');
    }
  }

  Card myCard(String imageIcon, Function onTap) {
    return Card(
      elevation: 0,
      color: AppColor.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            child: Image.asset(
              imageIcon,
              height: 25,
              width: 25,
            ),
          ),
        ),
      ),
    );
  }
}
