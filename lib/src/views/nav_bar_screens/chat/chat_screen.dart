import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/modals/app_user.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/views/nav_bar_screens/chat/chatting_screen.dart';
import 'package:bmind/src/views/nav_bar_screens/chat/message.dart';
import 'package:bmind/src/views/nav_bar_screens/chat/new_chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:badges/badges.dart';

import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: InkWell(
      //   onTap: () {
      //     Navigator.of(context)
      //         .push(MaterialPageRoute(builder: (context) => NewChat()));
      //   },
      //   child: CircleAvatar(
      //       backgroundColor: AppColor.primaryColor,
      //       radius: 22,
      //       child: Icon(Icons.add, color: Colors.white)),
      // ),
      appBar: AppUtils.appBar(false, 'Chats', context),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where(
              'user_id',
              whereIn: CurrentAppUser.currentUserData.messages.isEmpty
                  ? ['placehodter']
                  : CurrentAppUser.currentUserData.messages,
            )
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<AppUser> messagesList = [];
          snapshot.data.docs.forEach((element) {
            messagesList.add(AppUser.fromMap(element.data()));
          });
          print(messagesList);
          return messagesList.isEmpty
              ? Center(
                  child: Text('Message Someone'),
                )
              : ListView(
                  children: messagesList.map((e) {
                    return messagesList.first == e
                        ? Column(children: [
                            // Align(
                            //   alignment: Alignment.topLeft,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(13.0),
                            //     child: Text(
                            //       'Chats',
                            //       //style: AppTextStyle.boldTextStyle
                            //     ),
                            //   ),
                            // ),
                            messageItem(e)
                          ])
                        : messageItem(e);
                  }).toList(),
                );
        },
      ),
    );
  }

  Widget messageItem(AppUser e) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(CurrentAppUser.currentUserData.uid)
            .collection(e.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<Message> messagesList = [];
          snapshot.data.docs.forEach((element) {
            messagesList.add(Message.fromMap(element.data()));
          });
          int unRead = messagesList
              .where((msg) {
                if (msg.ownerId != CurrentAppUser.currentUserData.uid) {
                  if (!(msg.seen)) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              })
              .toList()
              .length;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                onMsgItemtab(e, context);
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.name,
                        //  style: TextStyle(color: primaryColor),
                      ),
                      Text(
                        timeago.format(
                            DateTime.parse(
                              messagesList.last.createdAt,
                            ),
                            locale: 'en_long'),
                        style: const TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          messagesList.last.message,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w300),
                        ),
                      ),
                      if (unRead > 0)
                        Badge(
                          // badgeColor: primaryColor,
                          badgeContent: Text(
                            '$unRead',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              leading: SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: e.photo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        });
  }

  void onMsgItemtab(AppUser e, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChattingScreen(
        appUser: e,
        currentUser: CurrentAppUser.currentUserData,
      ),
    ));
  }
}
