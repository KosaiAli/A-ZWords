import 'package:azwords/Function/worddata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Function/word.dart';
import '../Widget/wordsection.dart';

class WordsListScreen extends StatelessWidget {
  const WordsListScreen({
    Key? key,
    required FirebaseFirestore fireStore,
  })  : _fireStore = fireStore,
        super(key: key);

  final FirebaseFirestore _fireStore;

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return StreamBuilder<QuerySnapshot<Map>>(
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
                              wordProvider.words[index].data()['fav'],
                              wordProvider.words[index].data()['photoUrl']),
                        );
                      },
                      controller: wordProvider.scrollController),
                );
              }
              return Expanded(
                child: ListView.builder(
                  controller: wordProvider.scrollController,
                  itemCount: wordProvider.words.length,
                  itemBuilder: (context, index) {
                    if (wordProvider.words[index].data()['fav']) {
                      return WordSection(
                        word: Word(
                            wordProvider.words[index].id,
                            wordProvider.words[index].data()['meanings'],
                            wordProvider.words[index].data()['fav'],
                            wordProvider.words[index].data()['photoUrl']),
                      );
                    }
                    return Container();
                  },
                ),
              );
            }
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Images/NO_WORDS.png',
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
          });
    });
  }
}
