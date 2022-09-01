import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Widget/wordsection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late ScrollController _scrollcontroller;
  final _fireStore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _scrollcontroller = ScrollController()
      ..addListener(() {
        if (Provider.of<WordData>(context, listen: false).words.length > 4) {
          Provider.of<WordData>(context, listen: false)
              .setScrolling(_scrollcontroller.offset > 0);
        } else {
          Provider.of<WordData>(context, listen: false).setScrolling(false);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => StreamBuilder<
              QuerySnapshot<Map>>(
          stream: _fireStore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('words')
              .snapshots(),
          builder: (context, snapshot) {
            try {
              if (wordProvider.displayselected == 2) {
                List reversed = snapshot.data!.docs.reversed.toList();
                wordProvider.setWords(reversed);
              } else {
                wordProvider.setWords(snapshot.data!.docs);
              }
              // ignore: empty_catches
            } catch (e) {}
            if (wordProvider.words.isNotEmpty) {
              if (wordProvider.displayselected != 3) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: wordProvider.words.length,
                      itemBuilder: (context, index) {
                        return WordSection(
                          word: Word(
                              wordProvider.words[index].id,
                              wordProvider.words[index].data()['meanings'],
                              wordProvider.words[index].data()['fav']),
                        );
                      },
                      controller: _scrollcontroller),
                );
              }
              return Expanded(
                child: ListView.builder(
                    itemCount: wordProvider.words.length,
                    itemBuilder: (context, index) {
                      if (wordProvider.words[index].data()['fav']) {
                        return WordSection(
                          word: Word(
                              wordProvider.words[index].id,
                              wordProvider.words[index].data()['meanings'],
                              wordProvider.words[index].data()['fav']),
                        );
                      }
                      return const Text('');
                    },
                    controller: _scrollcontroller),
              );
            }
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'Assets/Images/NO_WORDS.png',
                    height: 200,
                  ),
                  const Text(
                    'There is no words \nTry to add some',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Icon(
                    Icons.arrow_downward_rounded,
                    size: 28,
                  )
                ],
              ),
            );
          }),
    );
  }
}
