import 'package:audioplayers/audioplayers.dart';
import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class WordScreen extends StatefulWidget {
  const WordScreen({Key? key, required this.word, this.callBack})
      : super(key: key);

  final Word word;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ClipRRect(
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 18),
                    height: 4,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 80,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  wordProvider.panelController.open();
                                  wordProvider
                                      .setonlineSearchedWord(widget.word.word);
                                  wordProvider.setmeanings(widget.word.meaning);
                                  wordProvider
                                      .setdeitingOrAddingWord(widget.word);

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: widget.word.photoURL != null
                                        ? null
                                        : Border.all(),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: widget.word.photoURL != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Image.network(
                                            widget.word.photoURL.toString(),
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress
                                                      ?.cumulativeBytesLoaded ==
                                                  loadingProgress
                                                      ?.expectedTotalBytes) {
                                                return child;
                                              }
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Shimmer.fromColors(
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  baseColor: Colors.grey[300]!,
                                                  child: Container(
                                                      width: 80,
                                                      height: 80,
                                                      color: Colors.white),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Image.asset(
                                            'assets/Images/no-photo.png',
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          widget.word.word,
                                          style: const TextStyle(
                                              height: 1.2,
                                              color: Colors.blue,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            play();
                                          },
                                          child: const Icon(
                                            Icons.volume_up_rounded,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            String uri =
                                                'https://translate.google.com/?sl=en&tl=ar&text=${widget.word.word}&op=translate';
                                            if (await url_launcher
                                                .canLaunchUrl(Uri.parse(uri))) {
                                              url_launcher
                                                  .launchUrl(Uri.parse(uri));
                                            }
                                          },
                                          child: const Icon(
                                            Icons.translate,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
                                    style: TextStyle(
                                        height: 1.2, color: Colors.grey[600]),
                                  )
                                ],
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
                                        .update({'fav': !widget.word.fav}).then(
                                            (value) {
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
                                  margin: EdgeInsets.zero,
                                  shadowColor: Colors.grey,
                                  color: Colors.white,
                                  elevation: 3,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: AnimatedScale(
                                      scale: widget.word.fav ? 1.1 : 1,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOutBack,
                                      child: _child),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            children: widget.word.getMeanings(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
