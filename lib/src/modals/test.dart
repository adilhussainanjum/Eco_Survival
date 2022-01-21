import 'package:cloud_firestore/cloud_firestore.dart';

class Test {
  String testId;
  String userId;
  Timestamp createdAt;
  double avgLeft;
  double avgRight;
  List<dynamic> leftList;
  List<dynamic> rightList;
  Test(
      {this.testId,
      this.userId,
      this.avgLeft,
      this.createdAt,
      this.avgRight,
      this.leftList,
      this.rightList});
  static Test fromMap(Map<String, dynamic> map) {
    Test test = Test();
    test.testId = map['test_id'].toString();
    test.avgRight = map['avg_right'];
    test.userId = map['user_id'];
    test.avgLeft = map['avg_left'];
    test.createdAt = map['created_at'];
    test.leftList = map['left'];
    test.rightList = map['right'];

    return test;
  }
}
