import 'package:azwords/Function/worddata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LengthInfo extends StatelessWidget {
  const LengthInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('words')
            .snapshots(),
        builder: (context, snapshot) {
          return Consumer<WordData>(
            builder: (context, wordProvider, child) => Text(
              wordProvider.selecting
                  ? '${wordProvider.selectedwords.length} selected'
                  : '${snapshot.data?.docs.length} word',
              style: TextStyle(
                  color: wordProvider.selecting ? Colors.blue : Colors.white,
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: wordProvider.selecting
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          );
        });
  }
}
