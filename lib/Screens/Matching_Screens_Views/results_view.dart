import 'dart:math';

import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/Matching_Screens_Views/result_pregress.dart';
import 'package:azwords/Screens/wordscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          .indexOf(e.toString());
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
              padding: const EdgeInsets.symmetric(vertical: 40),
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
                            width: MediaQuery.of(context).size.height * 0.175,
                            height: MediaQuery.of(context).size.height * 0.175,
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
            ...col()
          ],
        ),
      );
    });
  }
}
