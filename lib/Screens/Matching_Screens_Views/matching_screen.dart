import 'dart:math';

import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/Matching_Screens_Views/training_view.dart';
import 'package:azwords/Screens/wordscreen.dart';
import 'package:azwords/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({Key? key}) : super(key: key);

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  PageController pageController = PageController();
  int selectedNumber = 0;
  List<int> random = [];
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Matching',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 60, 20, 15),
                            child: Text(
                              'Choose the number of words you want to practise',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
                            child: Text(
                              'Since it is your first time here, we recommend to you choose small number',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  height: 1.2,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            width: double.infinity,
                            height: 190,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return NumberBox(
                                    number: index + 3,
                                    selecetedNumber: selectedNumber,
                                    callBack: (number) {
                                      if (number <= wordProvider.list.length) {
                                        if (number <=
                                            wordProvider.howmaynphotos) {
                                          setState(() {
                                            selectedNumber = number;
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              gravity: ToastGravity.SNACKBAR,
                                              msg:
                                                  'There is just ${wordProvider.howmaynphotos} words have photos',
                                              fontSize: 15,
                                              textColor: kPimaryColor,
                                              backgroundColor: Colors.white);
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            gravity: ToastGravity.SNACKBAR,
                                            msg:
                                                'You can\'t choose number bigger than ${wordProvider.list.length}',
                                            fontSize: 15,
                                            textColor: kPimaryColor,
                                            backgroundColor: Colors.white);
                                      }
                                    });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 30),
                            child: AnimatedScale(
                              scale: selectedNumber == 0 ? 0 : 1,
                              duration: const Duration(milliseconds: 200),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'Ready to go with $selectedNumber words?!',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          RawMaterialButton(
                            onPressed: () {
                              if (selectedNumber <= wordProvider.list.length &&
                                  selectedNumber != 0) {
                                pageController.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.linear);
                                random = [];
                                for (int i = 0; i < selectedNumber; i++) {
                                  int n = Random()
                                      .nextInt(wordProvider.list.length);
                                  while (random.contains(n) ||
                                      wordProvider.list[n].photoURL == null) {
                                    n = Random()
                                        .nextInt(wordProvider.list.length);
                                  }
                                  random.add(n);
                                }
                              }
                              wordProvider.setRaandom(random);
                              setState(() {});
                            },
                            fillColor: Colors.blue,
                            constraints: const BoxConstraints.expand(
                                height: 50, width: 120),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: const Text(
                              'Let\'s Go',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      TraingningScreen(
                        pageController: pageController,
                      ),
                      ResultScreen(
                        pageController: pageController,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class NumberBox extends StatelessWidget {
  const NumberBox(
      {Key? key,
      required this.number,
      required this.selecetedNumber,
      required this.callBack})
      : super(
          key: key,
        );

  final int number;
  final int selecetedNumber;
  final Function(int number) callBack;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBack(number);
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: number == selecetedNumber ? Colors.blue[100] : Colors.white,
            border: Border.all(
                color: number == selecetedNumber ? Colors.blue : Colors.black),
            borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        child: Text(
          '$number',
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    Provider.of<WordData>(context, listen: false).initAnimationController(this);

    animation = CurvedAnimation(
        parent: Tween(begin: 0.0, end: 1.0).animate(
            Provider.of<WordData>(context, listen: false).animationController)
          ..addListener(() {
            setState(() {});
          }),
        curve: Curves.fastOutSlowIn);
  }

  List<Widget> col() {
    return Provider.of<WordData>(context, listen: false).random.map((e) {
      final path =
          Provider.of<WordData>(context, listen: false).list[e].photoURL;
      int index = Provider.of<WordData>(context, listen: false)
          .results
          .keys
          .toList()
          .indexOf(e);
      return GestureDetector(
        onTap: () {
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
                  word: Provider.of<WordData>(context, listen: false).list[e]),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              height: 120,
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  path.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Provider.of<WordData>(context, listen: false).list[e].word,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  Text(
                    Provider.of<WordData>(context, listen: false)
                        .list[e]
                        .meaning[0]['definitions'][0]['definition'],
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, height: 1.5),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            Provider.of<WordData>(context, listen: false)
                    .results
                    .values
                    .elementAt(index)
                ? const Icon(
                    CupertinoIcons.checkmark_alt_circle_fill,
                    color: Colors.blue,
                    size: 28,
                  )
                : const Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: Colors.red,
                    size: 28,
                  )
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.pageController.animateTo(0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 10),
                              blurRadius: 15)
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(CupertinoIcons.back),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.height * 0.20,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Transform.rotate(
                    angle: -pi / 2,
                    child: CustomPaint(
                      painter: ResultProgress(
                          animation: animation.value,
                          correctOnes: wordProvider.howManyCorrect().toDouble(),
                          number: wordProvider.random.length),
                      child: Center(
                        child: Transform.rotate(
                          angle: pi * 0.50,
                          child: Container(
                            width: MediaQuery.of(context).size.height * 0.17,
                            height: MediaQuery.of(context).size.height * 0.17,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                '${wordProvider.howManyCorrect()} out of ${wordProvider.random.length}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(
                'Details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            Column(children: col())
          ],
        ),
      );
    });
  }
}

class ResultProgress extends CustomPainter {
  ResultProgress(
      {required this.number,
      required this.correctOnes,
      required this.animation});
  final int number;
  final double correctOnes;
  final double animation;

  @override
  void paint(Canvas canvas, Size size) {
    Offset c = Offset(size.width / 2, size.height / 2);
    double radius = max(size.height / 2, size.width / 2);
    Paint paint = Paint()
      ..strokeWidth = 23
      ..style = PaintingStyle.stroke
      ..color = Colors.grey;
    Path path = Path()
      ..addArc(Rect.fromCircle(center: c.translate(0, 10), radius: radius), 0,
          pi * 2)
      ..addArc(Rect.fromCircle(center: c.translate(0, -10), radius: radius), 0,
          pi * 2)
      ..addArc(Rect.fromCircle(center: c.translate(5, 0), radius: radius), 0,
          pi * 2);
    canvas.drawShadow(path, Colors.black, 20, true);
    canvas.drawCircle(c, radius, paint);
    canvas.drawArc(
        Rect.fromCenter(center: c, width: size.width, height: size.height),
        0,
        pi * animation * 2,
        false,
        paint..color = Colors.red);
    canvas.drawArc(
        Rect.fromCenter(center: c, width: size.width, height: size.height),
        0,
        pi * (correctOnes * animation / number) * 2,
        false,
        paint..color = Colors.blue);
    // canvas.drawCircle(
    //     c,
    //     radius - 10,
    //     paint
    //       ..style = PaintingStyle.fill
    //       ..color = Colors.white
    //       ..strokeWidth = 0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
