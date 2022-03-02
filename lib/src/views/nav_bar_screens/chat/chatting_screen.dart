import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/modals/app_user.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/views/nav_bar_screens/chat/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

class ChattingScreen extends StatelessWidget {
  final AppUser appUser;
  final CurrentAppUser currentUser;

  ChattingScreen({
    Key key,
    @required this.appUser,
    @required this.currentUser,
  }) : super(key: key);

  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppUtils.appBar(false, appUser.name, context),
        floatingActionButton: Container(
          color: Colors.white,
          child: MessageField(
            appUser: appUser,
            currentUser: currentUser,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: [
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection(appUser.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<Message> messagesList = [];
                  snapshot.data.docs.forEach((element) {
                    messagesList.add(Message.fromMap(element.data()));
                  });
                  updateStatus(snapshot.data.docs);
                  Future.delayed(Duration(seconds: 1), () {
                    _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: Duration(microseconds: 1),
                      curve: Curves.fastOutSlowIn,
                    );
                  });
                  return messagesList.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text('Start the Conversation'),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 70.0),
                            child: ListView.builder(
                              reverse: true,
                              // controller: _controller,
                              shrinkWrap: true,
                              itemCount: messagesList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MessageTile(
                                    message: messagesList[index],
                                    currentUser: currentUser,
                                    user: appUser);
                              },
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateStatus(List<QueryDocumentSnapshot> docs) async {
    for (int i = 0; i < docs.length; i++) {
      if ((docs[i].data() as Map<String, dynamic>)['ownerId'].toString() !=
          currentUser.uid) print("${docs[i].reference} === > status : true");
      await docs[i].reference.update({'seen': true});
    }
  }
}

class MessageTile extends StatelessWidget {
  final CurrentAppUser currentUser;
  final Message message;
  final AppUser user;
  const MessageTile(
      {Key key,
      @required this.currentUser,
      @required this.message,
      @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: message.ownerId == currentUser.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          // constraints: BoxConstraints(maxWidth: size.width * 0.7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: message.ownerId == currentUser.uid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              (currentUser.uid != message.ownerId)
                  ? user.photo != ''
                      ? SizedBox(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: user.photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.account_circle,
                            size: 40,
                            color: Colors.white,
                          ),
                        )
                  : Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 5),
                      child: Text(
                        DateTime.parse(message.createdAt).day ==
                                Timestamp.now().toDate().day
                            ? DateFormat('hh:mm a ')
                                .format(DateTime.parse(message.createdAt))
                            : DateFormat('dd MMM, hh:mm a  ')
                                .format(DateTime.parse(message.createdAt)),
                        style: TextStyle(
                            fontSize: size.width * 0.02,
                            color: const Color(0xff6B6B6B)),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: message.ownerId == currentUser.uid
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.ownerId == currentUser.uid
                          ? '  ${currentUser.name}'
                          : '  ${user.name}',
                      style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff6B6B6B)),
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffEFEDED)),
                          child: Text(
                            message.message,
                            style: TextStyle(fontSize: size.width * 0.04),
                          ),
                        ),
                        if (currentUser.uid != message.ownerId)
                          Text(
                            DateTime.parse(message.createdAt).day ==
                                    Timestamp.now().toDate().day
                                ? DateFormat(' hh:mm a')
                                    .format(DateTime.parse(message.createdAt))
                                : DateFormat(' dd MMM, hh:mm a')
                                    .format(DateTime.parse(message.createdAt)),
                            style: TextStyle(
                                fontSize: size.width * 0.02,
                                color: const Color(0xff6B6B6B)),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ),
              if (currentUser.uid == message.ownerId)
                SizedBox(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: CurrentAppUser.currentUserData.photo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _image(String url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            //backgroundColor: AppColor.appColor,
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.5, left: 1.5),
            child: Container(
              height: 47,
              width: 47,
              child: CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => (SafeArea(
                                child: Scaffold(
                                  backgroundColor: Colors.black,
                                  body: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ))),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Container(
                      child: CircleAvatar(
                        radius: 17,
                        backgroundImage: imageProvider,
                      ),
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(
                  Icons.error_outline,
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageField extends StatelessWidget {
  final AppUser appUser;
  final CurrentAppUser currentUser;
  final TextEditingController controller = TextEditingController();

  MessageField({
    Key key,
    @required this.appUser,
    @required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        alignment: Alignment.center,
        height: size.height * 0.08,
        width: size.width * 0.95,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColor.primaryColor, // red as border color
                  ),
                ),
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: controller,
                  expands: true,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 0, 8),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.send,
                        color: AppColor.primaryColor,
                      ),
                      onPressed: () async {
                        if (controller.text.trim().isEmpty) {
                          Fluttertoast.showToast(msg: 'Please write a message');
                        } else {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(appUser.uid)
                              .collection(currentUser.uid)
                              .add(
                                Message(
                                  ownerId: currentUser.uid,
                                  message: controller.text.trim(),
                                  seen: false,
                                  createdAt: Timestamp.now()
                                      .toDate()
                                      .toIso8601String(),
                                ).toMap(),
                              );
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser.uid)
                              .collection(appUser.uid)
                              .add(
                                Message(
                                  ownerId: currentUser.uid,
                                  message: controller.text.trim(),
                                  seen: false,
                                  createdAt: Timestamp.now()
                                      .toDate()
                                      .toIso8601String(),
                                ).toMap(),
                              );
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser.uid)
                              .update(
                            {
                              "messages": FieldValue.arrayUnion([appUser.uid]),
                            },
                          );

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(appUser.uid)
                              .update(
                            {
                              "messages":
                                  FieldValue.arrayUnion([currentUser.uid]),
                            },
                          );
                          controller.clear();
                        }
                      },
                    ),
                    hintText: "Write Message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
