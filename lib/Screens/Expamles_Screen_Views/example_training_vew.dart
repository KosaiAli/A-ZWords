import 'package:audioplayers/audioplayers.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExampleTrainingView extends StatefulWidget {
  const ExampleTrainingView({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;
  @override
  State<ExampleTrainingView> createState() => _ExampleTrainingViewState();
}

class _ExampleTrainingViewState extends State<ExampleTrainingView> {
  List<int> forWords = [];
  int selected = -1;
  bool shffeled = false;
  Color borderColor = Colors.blue;
  bool choosed = false;
  int selectedword = -1;
  int correctword = -1;
  int progress = 0;
  int exampleShown = 0;
  int exampleToShow = 0;
  AudioCache audioPlayer = AudioCache();
  late String? word;
  @override
  void initState() {
    Provider.of<WordData>(context, listen: false).initExamples();
    for (int i = 0;
        i < Provider.of<WordData>(context, listen: false).random.length;
        i++) {
      forWords.add(Provider.of<WordData>(context, listen: false).random[i]);
    }
    word = Provider.of<WordData>(context, listen: false)
        .nodes[0]
        ?.temp
        ?.sentence
        .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Text(
              word
                  .toString()
                  .replaceAll(
                      RegExp(wordProvider.nodes[progress]!.word.toString()),
                      ' ____ ')
                  .replaceAll(
                      RegExp(wordProvider.nodes[progress]!.word
                          .toString()
                          .replaceRange(
                              0,
                              1,
                              wordProvider.nodes[progress]!.word[0]
                                  .toUpperCase())),
                      ' ____ '),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: forWords.length,
              itemBuilder: (context, index) {
                if (index == 0 && !shffeled) {
                  forWords.shuffle();

                  shffeled = true;
                }
                return GestureDetector(
                  onTap: () {
                    if (!choosed) {
                      setState(() {
                        borderColor = Colors.blue;
                        selectedword = forWords[index];
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: selectedword == forWords[index]
                            ? Border.all(
                                color: borderColor,
                              )
                            : correctword == forWords[index]
                                ? Border.all(
                                    color: Colors.green,
                                  )
                                : Border.all(),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(wordProvider.list[forWords[index]].word
                        .replaceRange(
                            0,
                            1,
                            wordProvider.list[forWords[index]].word[0]
                                .toUpperCase())),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                choosed = true;
              });
              if (wordProvider.examples[wordProvider.random[progress]].word ==
                  wordProvider.examples[selectedword].word) {
                setState(() {
                  correctword = wordProvider.random[progress];
                  final result = <String, bool>{
                    wordProvider.nodes[progress]!.temp!.sentence: true
                  };
                  wordProvider.exResults.addEntries(result.entries);
                  borderColor = Colors.green;
                });
              } else {
                setState(() {
                  correctword = wordProvider.random[progress];
                  final result = <String, bool>{
                    wordProvider.nodes[progress]!.temp!.sentence: false
                  };
                  wordProvider.exResults.addEntries(result.entries);
                  borderColor = Colors.red;
                });
              }
            },
            constraints: const BoxConstraints.expand(height: 45, width: 120),
            fillColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              if (exampleShown < wordProvider.howmaenyex() - 1 && choosed) {
                wordProvider.nodes[progress]?.temp =
                    wordProvider.nodes[progress]?.temp?.next;
                if (progress < wordProvider.nodes.length - 1) {
                  progress++;
                } else {
                  progress = 0;
                }
                int end = progress;
                while (wordProvider.nodes[progress]?.temp?.sentence == null) {
                  if (progress < wordProvider.nodes.length - 1) {
                    progress++;
                  } else {
                    progress = 0;
                  }
                  if (progress == end) {
                    break;
                  }
                }
                setState(() {
                  word = wordProvider.nodes[progress]?.temp?.sentence;

                  selectedword = -1;
                  correctword = -1;
                  choosed = false;
                  shffeled = false;
                });
              }
              if (exampleShown == wordProvider.howmaenyex() - 1) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('Trainings')
                    .doc('Examples')
                    .collection('value')
                    .doc(DateTime.now().toString())
                    .set({'result': wordProvider.exResults});

                widget.pageController
                    .nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear)
                    .then(
                        (value) => wordProvider.animationController.forward());
              }

              exampleShown++;
            },
            constraints: const BoxConstraints.expand(height: 45, width: 120),
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              exampleShown == wordProvider.howmaenyex() - 1
                  ? 'See Result'
                  : 'Next',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          )
        ]),
      );
    });
  }
}
