// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class PostView extends StatefulWidget {
//   const PostView({ Key key }) : super(key: key);

//   @override
//   _PostViewState createState() => _PostViewState();
// }

// class _PostViewState extends State<PostView> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
//           child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(p.userId)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Text('Something went wrong!');
//                 }
//                 if (!snapshot.hasData) {
//                   return const Text("No Data Found");
//                 }
//                 Map<String, dynamic> a =
//                     snapshot.data.data() as Map<String, dynamic>;
//                 AppUser u = AppUser.fromMap(a);

//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 50,
//                       width: 50,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(30),
//                         child: CachedNetworkImage(
//                           imageUrl: u.photo,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               FittedBox(
//                                 child: SizedBox(
//                                   width: width * 0.25,
//                                   child: Text(
//                                     u.name,
//                                     style: AppTextStyles.simpleText.copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15),
//                                   ),
//                                 ),
//                               ),
//                               const Expanded(child: SizedBox()),
//                               SizedBox(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 4.0),
//                                   child: Text(
//                                       DateFormat('dd/MM/yyyy HH:mm')
//                                           .format(p.createdAt.toDate()),
//                                       style: AppTextStyles.smallText),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                                 child: PopupMenuButton(
//                                     padding: const EdgeInsets.all(0),
//                                     icon:
//                                         const Icon(Icons.more_horiz, size: 20),
//                                     iconSize: 10,
//                                     itemBuilder: (context) {
//                                       return [
//                                         PopupMenuItem(
//                                             padding: const EdgeInsets.all(5),
//                                             height: 20,
//                                             child: InkWell(
//                                               child: Text(
//                                                 "Report",
//                                                 style: AppTextStyles.mediumText,
//                                               ),
//                                               onTap: () {
//                                                 AppNavigator.push(context,
//                                                     const ReportPost());
//                                               },
//                                             )),
//                                       ];
//                                     }),
//                               )
//                             ],
//                           ),
//                           const SizedBox(height: 5),
//                           SizedBox(
//                             width: width,
//                             child: Text(p.post),
//                           ),
//                           SizedBox(height: height * 0.025),
//                           p.photoUrl != ''
//                               ? SizedBox(
//                                   height: height * 0.3,
//                                   width: width * 0.8,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: CachedNetworkImage(
//                                       imageUrl: p.photoUrl,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 )
//                               : Container(),
//                           SizedBox(height: height * 0.025),
//                           StatefulBuilder(builder: (context, state) {
//                             return Row(children: [
//                               InkWell(
//                                 onTap: () {
//                                   state(() {
//                                     p.show = !p.show;
//                                   });
//                                   toggleSetState(() {});
//                                 },
//                                 child: ClipRRect(
//                                   child: Image.asset(
//                                     AppAssetspath.comment,
//                                     fit: BoxFit.cover,
//                                     height: 20,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               StreamBuilder(
//                                   stream: FirebaseFirestore.instance
//                                       .collection('posts')
//                                       .doc(p.id)
//                                       .collection('comments')
//                                       .snapshots(),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const Center(
//                                           child: CircularProgressIndicator());
//                                     }
//                                     if (snapshot.hasError) {
//                                       return const Text(
//                                           'Something went wrong!');
//                                     }
//                                     if (!snapshot.hasData) {
//                                       return const Text("No Data Found");
//                                     }
//                                     List<
//                                             QueryDocumentSnapshot<
//                                                 Map<String, dynamic>>> docList =
//                                         snapshot.data.docs;
//                                     int numberOfComments = docList.length;
//                                     List<Comments> comments = [];
//                                     docList.forEach((element) {
//                                       Comments p =
//                                           Comments.fromMap(element.data());
//                                       comments.add(p);
//                                     });

//                                     return Column(
//                                         children: comments
//                                             .map((e) => Text(
//                                                 '$numberOfComments',
//                                                 style:
//                                                     AppTextStyles.simpleText))
//                                             .toList());
//                                   }),
//                               SizedBox(width: width * 0.1),
//                               InkWell(
//                                 onTap: () async {
//                                   isLoading_ = true;

//                                   if (isLoading_) {
//                                     isLiked = !isLiked;

//                                     isLiked
//                                         ? await FirebaseFirestore.instance
//                                             .collection('posts')
//                                             .doc(p.id)
//                                             .update({
//                                             'likes': FieldValue.arrayUnion([
//                                               CurrentAppUser.currentUserData.uid
//                                             ])
//                                           })
//                                         : await FirebaseFirestore.instance
//                                             .collection('posts')
//                                             .doc(p.id)
//                                             .update({
//                                             'likes': FieldValue.arrayRemove([
//                                               CurrentAppUser.currentUserData.uid
//                                             ])
//                                           });
//                                     state(() {
//                                       isLiked
//                                           ? p.likes.add(CurrentAppUser
//                                               .currentUserData.uid)
//                                           : p.likes.remove(CurrentAppUser
//                                               .currentUserData.uid);
//                                     });

//                                     isLoading_ = false;
//                                   }
//                                 },
//                                 child: SizedBox(
//                                     child: !isLiked
//                                         ? const Icon(
//                                             Icons.favorite_border_rounded)
//                                         : Icon(Icons.favorite_rounded,
//                                             color: AppColor.primaryColor)),
//                               ),
//                               const SizedBox(width: 10),
//                               Text(p.likes.length.toString(),
//                                   style: AppTextStyles.simpleText),
//                             ]);
//                           }),
//                           SizedBox(height: height * 0.02),
//                           StatefulBuilder(builder: (context, myState) {
//                             toggleSetState = myState;
//                             return StreamBuilder(
//                                 stream: FirebaseFirestore.instance
//                                     .collection('posts')
//                                     .doc(p.id)
//                                     .collection('comments')
//                                     .snapshots(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return const Center(
//                                         child: CircularProgressIndicator());
//                                   }
//                                   if (snapshot.hasError) {
//                                     return const Text('Something went wrong!');
//                                   }
//                                   if (!snapshot.hasData) {
//                                     return const Text("No Data Found");
//                                   }
//                                   List<
//                                           QueryDocumentSnapshot<
//                                               Map<String, dynamic>>> docList =
//                                       snapshot.data.docs;

//                                   List<Comments> comments = [];
//                                   docList.forEach((element) {
//                                     Comments p =
//                                         Comments.fromMap(element.data());
//                                     comments.add(p);
//                                   });
//                                   return Column(
//                                       children: comments
//                                           .map(
//                                             (e) => p.show
//                                                 ? CommentField(
//                                                     comment: e,
//                                                     postId : p.id
//                                                   )
//                                                 : SizedBox(),
//                                           )
//                                           .toList());
//                                 });
//                           }),
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//               }),
//         ))
//     );
//   }
// }