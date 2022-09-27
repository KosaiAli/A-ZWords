import 'dart:convert';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/themebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Function/word.dart';

class OnlineAddingSection extends StatefulWidget {
  const OnlineAddingSection({
    Key? key,
  }) : super(key: key);

  // String word;
  @override
  State<OnlineAddingSection> createState() => _AddingWordSectionState();
}

class _AddingWordSectionState extends State<OnlineAddingSection> {
  late Widget _child;
  String word = '';
  dynamic jsoncode;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    focusNode.unfocus();
    _child = Text(word,
        style: const TextStyle(
          color: Colors.white,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordData, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: AnimatedOpacity(
          opacity: wordData.adding ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Stack(
            children: [
              IgnorePointer(
                ignoring: word == '' ? true : false,
                child: GestureDetector(
                  onTap: () {
                    focusNode.unfocus();
                    if (jsoncode != null) {
                      showModalBottomSheet(
                        backgroundColor: const Color(0x00737373),
                        context: context,
                        builder: (context) => Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35))),
                          child: WordS(
                            word: Word(jsoncode[0]['word'],
                                jsoncode[0]['meanings'], false, null),
                            jsoncode: jsoncode,
                          ),
                        ),
                      );
                    }
                  },
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInExpo,
                    padding: EdgeInsets.only(
                        top: textEditingController.value.text == '' ? 10 : 47),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: textEditingController.value.text == '' ? 0 : 1,
                      child: AnimatedContainer(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        duration: const Duration(milliseconds: 800),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: const Radius.circular(35),
                                bottomRight: const Radius.circular(35),
                                topLeft: textEditingController.value.text == ''
                                    ? const Radius.circular(20)
                                    : Radius.zero,
                                topRight: textEditingController.value.text == ''
                                    ? const Radius.circular(20)
                                    : Radius.zero),
                            border: Border.all(color: Colors.blue)),
                        child: Center(child: _child),
                      ),
                    ),
                  ),
                ),
              ),
              TextField(
                focusNode: focusNode,
                onTap: () {},
                onChanged: (value) async {
                  setState(() {
                    word = '';

                    _child = const SpinKitThreeBounce(
                      color: Colors.blue,
                      size: 12.5,
                    );
                  });
                  var url =
                      'https://api.dictionaryapi.dev/api/v2/entries/en/$value';
                  try {
                    var res = await http.get(Uri.parse(url));

                    if (res.statusCode == 200 &&
                        textEditingController.text ==
                            jsonDecode(res.body)[0]['word']) {
                      jsoncode = jsonDecode(res.body);

                      setState(() {
                        word = jsoncode[0]['word'];
                        _child = Text(word,
                            style: const TextStyle(
                              color: Colors.white,
                            ));
                      });
                    } else {
                      if (textEditingController.text == value) {
                        setState(() {
                          word = 'word was not found';
                          _child = Text(word,
                              style: const TextStyle(
                                color: Colors.white,
                              ));
                        });
                      }
                    }
                  } catch (e) {
                    return;
                  }
                },
                controller: textEditingController,
                cursorHeight: 20,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, height: 1.2),
                decoration: InputDecoration(
                  fillColor: Theme.of(context).backgroundColor,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  labelText: 'Search online',
                  labelStyle:
                      const TextStyle(color: Colors.white, fontSize: 14),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(
                            textEditingController.value.text == '' ? 20 : 1),
                        bottomRight: Radius.circular(
                            textEditingController.value.text == '' ? 20 : 0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 22, 151, 202),
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(
                            textEditingController.value.text == '' ? 20 : 0),
                        bottomRight: Radius.circular(
                            textEditingController.value.text == '' ? 20 : 0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WordS extends StatefulWidget {
  const WordS({Key? key, required this.jsoncode, required this.word})
      : super(key: key);

  final dynamic jsoncode;
  final Word word;
  @override
  State<WordS> createState() => _WordSState();
}

class _WordSState extends State<WordS> {
  String def = '';
  List<dynamic> meanings = [];
  List<Widget> getdefinations(int index) {
    //0.meanings[0].definitions[0].synonyms  0.meanings[0].definitions[1].synonyms
    List<dynamic> definitation =
        widget.jsoncode[0]['meanings'][index]['definitions'];

    final lis = definitation.map((e) {
      int index2 = definitation.indexOf(e);
      String example = '';
      if (widget.jsoncode[0]['meanings'][index]['definitions'][index2]
              ['example'] !=
          null) {
        example = widget.jsoncode[0]['meanings'][index]['definitions'][index2]
            ['example'];
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                '${index2 + 1}- ${widget.jsoncode[0]['meanings'][index]['definitions'][index2]['definition']}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (example != '')
              Text(
                'example : $example',
              ),
          ],
        ),
      );
    }).toList();
    return lis;
  }

  List<Widget> getMeanings() {
    meanings = widget.jsoncode[0]['meanings'];

    final m = meanings.map((e) {
      final index = meanings.indexOf(e);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.jsoncode[0]['meanings'][index]['partOfSpeech']}:',
              style: const TextStyle(fontSize: 18),
            ),
            Column(
              children: getdefinations(index),
            )
          ],
        ),
      );
    }).toList();

    return m;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 40, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.jsoncode[0]['word'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      height: 1.2,
                      color: Colors.blue,
                      letterSpacing: 0.5,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      wordProvider
                          .setonlineSearchedWord(widget.jsoncode[0]['word']);
                      wordProvider.panelController.open();
                      wordProvider.setjsoncode(widget.jsoncode);
                      wordProvider.setmeanings(meanings);
                    },
                    fillColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                    constraints:
                        const BoxConstraints.expand(height: 40, width: 40),
                    child: Icon(Icons.add,
                        color: ThemeBuilder.of(context)?.themeMode ==
                                ThemeMode.light
                            ? Colors.white
                            : Colors.black),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Meaning:',
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 0.4),
                    ),
                  ),
                  Column(
                    children: getMeanings(),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
