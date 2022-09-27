import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/test_screen.dart';
import 'package:azwords/Screens/words_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordsList extends StatefulWidget {
  const WordsList({
    Key? key,
  }) : super(key: key);

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  final _fireStore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    Provider.of<WordData>(context, listen: false).setListner();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      if (wordProvider.barButtonSelected == 2) {
        return const TestScreen();
      }

      return WordsListScreen(fireStore: _fireStore);
    });
  }
}
