import 'dart:math';

import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/Matching_Screens_Views/result_pregress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExampleResultScreen extends StatefulWidget {
  const ExampleResultScreen({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;
  @override
  State<ExampleResultScreen> createState() => _ExampleResultScreenState();
}

class _ExampleResultScreenState extends State<ExampleResultScreen>
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
    return Provider.of<WordData>(context, listen: false)
        .exResults
        .keys
        .map((e) {
      // final path =
      //     Provider.of<WordData>(context, listen: false).list[e].photoURL;
      int index = Provider.of<WordData>(context, listen: false)
          .exResults
          .keys
          .toList()
          .indexOf(e);
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Text(
                    e,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Provider.of<WordData>(context, listen: false)
                      .exResults
                      .values
                      .elementAt(index)
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Icon(
                        CupertinoIcons.checkmark_alt_circle_fill,
                        color: Colors.blue,
                        size: 28,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(24),
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
            ],
          ),
          if (index <
              Provider.of<WordData>(context, listen: false)
                      .exResults
                      .keys
                      .toList()
                      .length -
                  1)
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width / 2,
              color: Colors.grey,
            )
        ],
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
                          correctOnes:
                              wordProvider.howManyExamplesCorrect().toDouble(),
                          number: wordProvider.exResults.length),
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
                                '${wordProvider.howManyExamplesCorrect()} out of ${wordProvider.exResults.length}',
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
