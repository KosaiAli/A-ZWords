import 'package:audioplayers/audioplayers.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TraingningScreen extends StatefulWidget {
  const TraingningScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  State<TraingningScreen> createState() => _TraingningScreenState();
}

class _TraingningScreenState extends State<TraingningScreen> {
  List<int> forPhoto = [];
  int selected = -1;
  bool shffeled = false;
  Color borderColor = Colors.blue;
  bool choosed = false;
  int selctedPhoto = -1;
  int correctPhoto = -1;
  int progress = 0;
  AudioCache audioPlayer = AudioCache();
  @override
  void initState() {
    super.initState();
    for (var element in Provider.of<WordData>(context, listen: false).random) {
      forPhoto.add(element);
    }
    Provider.of<WordData>(context, listen: false).results.clear();
  }

  void play(String path) async {
    await audioPlayer.play(path);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  wordProvider.list[wordProvider.random[progress]].word,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: forPhoto.length <= 4 ? 2 : 3,
                  mainAxisSpacing: 10),
              itemCount: forPhoto.length,
              itemBuilder: (context, index) {
                if (index == 0 && !shffeled) {
                  forPhoto.shuffle();

                  shffeled = true;
                }
                return GestureDetector(
                  onTap: () {
                    if (!choosed) {
                      setState(() {
                        borderColor = Colors.blue;
                        selctedPhoto = forPhoto[index];
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: selctedPhoto == forPhoto[index]
                          ? Border.all(
                              color: borderColor,
                              width: 3,
                              strokeAlign: StrokeAlign.outside)
                          : correctPhoto == forPhoto[index]
                              ? Border.all(
                                  color: Colors.green,
                                  width: 3,
                                  strokeAlign: StrokeAlign.outside)
                              : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        wordProvider.list[forPhoto[index]].photoURL.toString(),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress?.cumulativeBytesLoaded ==
                              loadingProgress?.expectedTotalBytes) {
                            return child;
                          }
                          return Shimmer.fromColors(
                            highlightColor: Colors.grey[100]!,
                            baseColor: Colors.grey[300]!,
                            child: Container(color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      choosed = true;
                    });

                    if (wordProvider.list[selctedPhoto].photoURL ==
                            wordProvider
                                .list[wordProvider.random[progress]].photoURL &&
                        correctPhoto == -1) {
                      setState(() {
                        final result = <String, bool>{
                          '${wordProvider.random[progress]}': true
                        };
                        wordProvider.results.addEntries(result.entries);
                        correctPhoto = wordProvider.random[progress];
                        borderColor = Colors.green;
                        play('sounds/correct-answer.wav');
                      });
                    } else if (wordProvider.list[selctedPhoto].photoURL !=
                            wordProvider
                                .list[wordProvider.random[progress]].photoURL &&
                        correctPhoto == -1) {
                      setState(() {
                        final result = <String, bool>{
                          '${wordProvider.random[progress]}': false
                        };
                        wordProvider.results.addEntries(result.entries);

                        play('sounds/wrong-answer.wav');
                        correctPhoto = wordProvider.random[progress];
                        borderColor = Colors.red;
                      });
                    }
                  },
                  constraints:
                      const BoxConstraints.expand(height: 45, width: 120),
                  fillColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    'Check',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RawMaterialButton(
                  onPressed: () async {
                    if (progress < wordProvider.random.length - 1 && choosed) {
                      setState(() {
                        progress++;
                        selctedPhoto = -1;
                        correctPhoto = -1;
                        choosed = false;
                        shffeled = false;
                      });
                    } else if (progress == wordProvider.random.length - 1 &&
                        choosed) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection('Trainings')
                          .doc('Matching')
                          .collection('value')
                          .doc(DateTime.now().toString())
                          .set({'result': wordProvider.results});

                      widget.pageController
                          .nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.linear)
                          .then((value) =>
                              wordProvider.animationController.forward());
                    }
                  },
                  constraints:
                      const BoxConstraints.expand(height: 45, width: 120),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    progress == wordProvider.random.length - 1
                        ? 'See Result'
                        : 'Next',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }
}
