import 'package:audioplayers/audioplayers.dart';
import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordScreen extends StatefulWidget {
  const WordScreen(
      {Key? key, required this.word, required this.index, this.callBack})
      : super(key: key);

  final Word word;
  final int index;
  final Function(bool value)? callBack;
  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  List<String> meaning = [];

  late AudioPlayer audioPlayer;
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late Widget _child;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _child = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Icon(
          widget.word.fav ? Icons.favorite : Icons.favorite_border_sharp,
          color: widget.word.fav ? Colors.blue : Colors.black),
    );

    // meaning = widget.word.meaning.split(',');
  }

  void play() async {
    var url =
        'https://api.dictionaryapi.dev/media/pronunciations/en/${widget.word.word}-us.mp3';

    int result = await audioPlayer.play(url);

    if (result == 1) {
      // success
    }
  }

  List<Widget> getdefinations(int index) {
    List<dynamic> definitation = widget.word.meaning[index]['definitions'];

    final lis = definitation.map((e) {
      int index2 = definitation.indexOf(e);
      String example = '';
      if (widget.word.meaning[index]['definitions'][index2]['example'] !=
          null) {
        example = widget.word.meaning[index]['definitions'][index2]['example'];
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                '${index2 + 1}- ${widget.word.meaning[index]['definitions'][index2]['definition']}',
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
    List meanings = widget.word.meaning;

    final m = meanings.map((e) {
      final index = meanings.indexOf(e);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.word.meaning[index]['partOfSpeech']}:',
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
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.word.word,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 28,
                      fontFamily: 'LuckiestGuy',
                      letterSpacing: 0.5),
                ),
                const SizedBox(
                  width: 10,
                ),
                RawMaterialButton(
                  onPressed: () {
                    play();
                  },
                  highlightColor: Colors.grey[300],
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  constraints:
                      const BoxConstraints.tightFor(width: 30, height: 30),
                  child: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _child = Transform.scale(
                          scale: 0.5,
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: CircularProgressIndicator(),
                          ));
                    });
                    try {
                      await _fireStore
                          .collection('users')
                          .doc(_auth.currentUser?.uid)
                          .collection('words')
                          .doc(widget.word.word)
                          .update({'fav': !widget.word.fav}).then((value) {
                        setState(() {
                          widget.word.fav = !widget.word.fav;
                          if (widget.callBack != null) {
                            widget.callBack!(widget.word.fav);
                          }
                          _child = Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                                widget.word.fav
                                    ? Icons.favorite
                                    : Icons.favorite_border_sharp,
                                color: widget.word.fav
                                    ? Colors.blue
                                    : Colors.black),
                          );
                        });
                      });
                    } catch (e) {
                      return;
                    }
                  },
                  child: Card(
                    shadowColor: Colors.grey,
                    color: Colors.white,
                    elevation: 3,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: AnimatedScale(
                        scale: widget.word.fav ? 1.1 : 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutBack,
                        child: _child),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: getMeanings(),
              ),
            )
          ],
        ),
      );
    });
  }
}
