import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/constants/assets_path.dart';
import 'package:bmind/src/modals/app_user.dart';
import 'package:bmind/src/modals/artical.dart';
import 'package:bmind/src/modals/comments.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/modals/post.dart';
import 'package:bmind/src/utils/app_navigator.dart';
import 'package:bmind/src/utils/app_utils.dart';
import 'package:bmind/src/utils/styles/text_styles.dart';
import 'package:bmind/src/utils/text_field.dart';
import 'package:bmind/src/views/nav_bar_screens/Home/add_post.dart';
import 'package:bmind/src/views/nav_bar_screens/Home/comment.dart';
import 'package:bmind/src/views/nav_bar_screens/Home/edit_post.dart';
import 'package:bmind/src/views/nav_bar_screens/Home/my_article.dart';
import 'package:bmind/src/views/nav_bar_screens/Home/report_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  double height;
  double width;

  TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    CurrentAppUser.currentUserData.addListener(() {
      //setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppUtils.appBar(false, 'Community', context),
        floatingActionButton: InkWell(
          onTap: () {
            AppNavigator.push(context, const AddPost());
          },
          child: CircleAvatar(
            backgroundColor: AppColor.navBarGrey,
            child: Icon(
              Icons.add,
              color: AppColor.headingTextColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: width * 0.95,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('Articles', style: AppTextStyles.headingText),
                      ),
                    ],
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('articles')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Text('Something went wrong!');
                        }
                        if (!snapshot.hasData) {
                          return const Text("No Data Found");
                        }
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            docList = snapshot.data.docs;
                        List<Article> articles = [];
                        docList.forEach((element) {
                          Article a = Article.fromMap(element.data());
                          articles.add(a);
                        });

                        return SizedBox(
                            width: width,
                            height: height * 0.15,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Article a = Article.fromMap(
                                      (snapshot.data.docs[index].data()
                                          as Map<String, dynamic>));

                                  return Card(
                                    child: InkWell(
                                      onTap: () {
                                        AppNavigator.push(
                                            context, MyArticle(a));
                                      },
                                      child: SizedBox(
                                          width: width * 0.35,
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Html(
                                              data: a.article,
                                              // maxLines: 1,
                                              // overflow: TextOverflow.ellipsis,
                                              // softWrap: false,
                                            ),
                                          ))),
                                    ),
                                  );
                                }));
                      }),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('Community', style: AppTextStyles.headingText),
                      ),
                    ],
                  ),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .orderBy('created_at', descending: true)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Text('Something went wrong!');
                        }
                        if (!snapshot.hasData) {
                          return const Text("No Data Found");
                        }

                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            docList = snapshot.data.docs;
                        List<Post> posts = [];
                        docList.forEach((element) {
                          Post p = Post.fromMap(element.data());
                          posts.add(p);
                        });

                        return Column(
                            children: posts
                                .map(
                                  (e) => postCard(e),
                                )
                                .toList());
                      }),
                ],
              ),
            ),
          ),
        ));
  }

  Card postCard(Post p) {
    bool isLiked = p.likes.contains(CurrentAppUser.currentUserData.uid);
    bool isLoading_ = false;
    p.show = false;
    var toggleSetState;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(p.userId)
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
                AppUser u = AppUser.fromMap(a);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: u.photo == ''
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Icon(
                                Icons.account_circle_rounded,
                                size: 50,
                                color: AppColor.greyColor,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CachedNetworkImage(
                                imageUrl: u.photo,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: SizedBox(
                                  width: width * 0.25,
                                  child: Text(
                                    u.name,
                                    style: AppTextStyles.simpleText.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                      DateFormat('dd/MM/yyyy HH:mm')
                                          .format(p.createdAt.toDate()),
                                      style: AppTextStyles.smallText),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                                child: PopupMenuButton(
                                    padding: const EdgeInsets.all(0),
                                    icon:
                                        const Icon(Icons.more_horiz, size: 20),
                                    iconSize: 10,
                                    itemBuilder: (context) {
                                      return p.userId ==
                                              CurrentAppUser.currentUserData.uid
                                          ? [
                                              PopupMenuItem(
                                                  child: InkWell(
                                                child: Text(
                                                  "Delete Post",
                                                  style:
                                                      AppTextStyles.simpleText,
                                                ),
                                                onTap: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('posts')
                                                      .doc(p.id)
                                                      .delete();
                                                },
                                              )),
                                              PopupMenuItem(
                                                  child: InkWell(
                                                child: Text(
                                                  "Edit Post",
                                                  style:
                                                      AppTextStyles.simpleText,
                                                ),
                                                onTap: () {
                                                  AppNavigator.push(
                                                      context, EditPost(p));
                                                },
                                              )),
                                              PopupMenuItem(
                                                  // padding: const EdgeInsets.all(5),
                                                  // height: 20,
                                                  child: InkWell(
                                                child: Text(
                                                  "Report Post",
                                                  style:
                                                      AppTextStyles.simpleText,
                                                ),
                                                onTap: () {
                                                  AppNavigator.push(context,
                                                      const ReportPost());
                                                },
                                              )),
                                            ]
                                          : [
                                              PopupMenuItem(
                                                  child: InkWell(
                                                child: Text(
                                                  "Report Post",
                                                  style:
                                                      AppTextStyles.simpleText,
                                                ),
                                                onTap: () {
                                                  AppNavigator.push(context,
                                                      const ReportPost());
                                                },
                                              )),
                                            ];
                                    }),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: width,
                            child: Text(p.post),
                          ),
                          SizedBox(height: height * 0.025),
                          p.photoUrl != ''
                              ? SizedBox(
                                  height: height * 0.3,
                                  width: width * 0.8,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: p.photoUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(height: height * 0.025),
                          StatefulBuilder(builder: (context, state) {
                            return Row(children: [
                              InkWell(
                                onTap: () {
                                  state(() {
                                    p.show = !p.show;
                                  });
                                  toggleSetState(() {});
                                },
                                child: ClipRRect(
                                  child: Image.asset(
                                    AppAssetspath.comment,
                                    fit: BoxFit.cover,
                                    height: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(p.id)
                                      .collection('comments')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(child: Text('..'));
                                    }
                                    if (snapshot.hasError) {
                                      return const Text(
                                          'Something went wrong!');
                                    }
                                    if (!snapshot.hasData) {
                                      return const Text("No Data Found");
                                    }
                                    List<
                                            QueryDocumentSnapshot<
                                                Map<String, dynamic>>> docList =
                                        snapshot.data.docs;
                                    int numberOfComments = docList.length;
                                    List<Comments> comments = [];
                                    docList.forEach((element) {
                                      Comments p =
                                          Comments.fromMap(element.data());
                                      comments.add(p);
                                    });

                                    return Text('${comments.length}',
                                        style: AppTextStyles.simpleText);
                                  }),
                              SizedBox(width: width * 0.1),
                              InkWell(
                                onTap: () async {
                                  isLoading_ = true;

                                  if (isLoading_) {
                                    isLiked = !isLiked;

                                    isLiked
                                        ? await FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(p.id)
                                            .update({
                                            'likes': FieldValue.arrayUnion([
                                              CurrentAppUser.currentUserData.uid
                                            ])
                                          })
                                        : await FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(p.id)
                                            .update({
                                            'likes': FieldValue.arrayRemove([
                                              CurrentAppUser.currentUserData.uid
                                            ])
                                          });
                                    state(() {
                                      isLiked
                                          ? p.likes.add(CurrentAppUser
                                              .currentUserData.uid)
                                          : p.likes.remove(CurrentAppUser
                                              .currentUserData.uid);
                                    });

                                    isLoading_ = false;
                                  }
                                },
                                child: SizedBox(
                                    child: !isLiked
                                        ? const Icon(
                                            Icons.favorite_border_rounded)
                                        : Icon(Icons.favorite_rounded,
                                            color: AppColor.primaryColor)),
                              ),
                              const SizedBox(width: 10),
                              Text(p.likes.length.toString(),
                                  style: AppTextStyles.simpleText),
                            ]);
                          }),
                          SizedBox(height: height * 0.02),
                          StatefulBuilder(builder: (context, myState) {
                            toggleSetState = myState;
                            return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(p.id)
                                    .collection('comments')
                                    .orderBy(
                                      'created_at',
                                    )
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong!');
                                  }
                                  if (!snapshot.hasData) {
                                    return const Text("No Data Found");
                                  }
                                  List<
                                          QueryDocumentSnapshot<
                                              Map<String, dynamic>>> docList =
                                      snapshot.data.docs;

                                  List<Comments> comments = [];
                                  docList.forEach((element) {
                                    Comments p =
                                        Comments.fromMap(element.data());
                                    comments.add(p);
                                  });
                                  return Column(children: [
                                    ...comments
                                        .map(
                                          (e) => AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: p.show
                                                  ? CommentField(
                                                      comment: e,
                                                    )
                                                  : SizedBox()),
                                        )
                                        .toList(),
                                    p.show
                                        ? StatefulBuilder(
                                            builder: (context, state) {
                                            return GestureDetector(
                                              child: myTextField(
                                                  label:
                                                      'Tap here to Write your Comment',
                                                  controller:
                                                      _commentController,
                                                  suffixiconbutton: IconButton(
                                                      onPressed: () {
                                                        if (_commentController
                                                            .text.isNotEmpty) {
                                                          DocumentReference
                                                              docRef =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'posts')
                                                                  .doc(p.id)
                                                                  .collection(
                                                                      'comments')
                                                                  .doc();
                                                          docRef.set({
                                                            'created_at':
                                                                Timestamp.now(),
                                                            'user_id':
                                                                CurrentAppUser
                                                                    .currentUserData
                                                                    .uid,
                                                            'title':
                                                                _commentController
                                                                    .text,
                                                            'comment_id':
                                                                docRef.id,
                                                          });
                                                          _commentController
                                                              .clear();
                                                        }
                                                      },
                                                      icon: Icon(Icons.send))),
                                            );
                                          })
                                        : SizedBox()
                                  ]);
                                });
                          }),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
