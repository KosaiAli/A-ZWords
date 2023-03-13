import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String? profilePic;
  QuerySnapshot<Map<String, dynamic>> res;
  QuerySnapshot<Map<String, dynamic>> res2;
  List<dynamic> words;
  User(
      {required this.name,
      required this.words,
      this.profilePic,
      required this.res,
      required this.res2});
}
