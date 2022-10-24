import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/wordscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FocusNode searchFN;
  String searchingword = '';
  List<Word> searchedWords = [];

  @override
  void initState() {
    searchFN = FocusNode();
    searchFN.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    RawMaterialButton(
                      constraints:
                          const BoxConstraints(minHeight: 40, minWidth: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, size: 28),
                    ),
                    Expanded(
                      flex: 6,
                      child: TextField(
                        onChanged: ((value) {
                          setState(() {
                            searchingword = value.trim();
                            searchedWords = wordProvider.search(value.trim());
                          });
                        }),
                        focusNode: searchFN,
                        cursorHeight: 24,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: 'Write the word',
                          contentPadding: EdgeInsets.only(bottom: 7),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    searchFN.unfocus();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: searchedWords.isNotEmpty
                        ? ListView.builder(
                            itemCount: searchedWords.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return RawMaterialButton(
                                splashColor: Colors.blue,
                                constraints:
                                    const BoxConstraints(minHeight: 60),
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        'do you want to delete this word',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        RawMaterialButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser?.uid)
                                                .collection('words')
                                                .doc(searchedWords[index].word)
                                                .delete()
                                                .then((value) {
                                              setState(() {
                                                searchedWords.removeAt(index);
                                              });
                                              if (wordProvider.words.length <=
                                                  5) {
                                                Provider.of<WordData>(context,
                                                        listen: false)
                                                    .setScrolling(false);
                                              }
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text('yes'),
                                        ),
                                        RawMaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('no'),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                onPressed: () {
                                  searchFN.unfocus();
                                  showModalBottomSheet(
                                    backgroundColor: const Color(0x00737373),
                                    context: context,
                                    builder: (context) => Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(35),
                                              topRight: Radius.circular(35))),
                                      child: WordScreen(
                                        word: searchedWords[index],
                                        callBack: (value) {
                                          setState(() {
                                            searchedWords[index].fav = value;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            searchedWords[index].word,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          // Text(
                                          //   searchedWords[index].meaning[0],
                                          //   style: const TextStyle(
                                          //     fontSize: 15,
                                          //     letterSpacing: 0.5,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      if (searchedWords[index].fav)
                                        const Icon(
                                          Icons.favorite,
                                          color: Colors.blue,
                                          size: 22,
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : searchingword != ''
                            ? const Text('Word was not found')
                            : const Text(''),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
