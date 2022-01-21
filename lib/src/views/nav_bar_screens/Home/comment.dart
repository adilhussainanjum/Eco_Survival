import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/modals/app_user.dart';
import 'package:bmind/src/modals/comments.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentField extends StatefulWidget {
  CommentField({this.comment, this.postId, key}) : super(key: key);
  final Comments comment;
  String postId;

  @override
  _CommentFieldState createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  double height;
  double width;
  final _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.comment.userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text('Something went wrong!');
                }
                if (!snapshot.hasData) {
                  return const Text("No Data Found");
                }
                Map<String, dynamic> a =
                    snapshot.data.data() as Map<String, dynamic>;
                AppUser user = AppUser.fromMap(a);

                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
                        child: Row(children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: user.photo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.05),
                          Text(user.name,
                              style: AppTextStyles.simpleText,
                              textAlign: TextAlign.center)
                        ]),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Text(widget.comment.title,
                            textAlign: TextAlign.left,
                            style: AppTextStyles.smallText),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
