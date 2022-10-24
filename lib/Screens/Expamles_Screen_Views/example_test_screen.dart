import 'dart:math';

import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/Expamles_Screen_Views/example_result_view.dart';
import 'package:azwords/Screens/Expamles_Screen_Views/example_training_vew.dart';
import 'package:azwords/Screens/Matching_Screens_Views/matching_screen.dart';
import 'package:azwords/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ExampleTestScreen extends StatefulWidget {
  const ExampleTestScreen({Key? key}) : super(key: key);

  @override
  State<ExampleTestScreen> createState() => _ExampleTestScreenState();
}

class _ExampleTestScreenState extends State<ExampleTestScreen> {
  PageController pageController = PageController();
  int selectedNumber = 0;
  List<int> random = [];

  List<Widget> col() {
    List n = [3, 4, 5, 6, 7];
    return n.map((e) {
      return NumberBox(
          number: e,
          selecetedNumber: selectedNumber,
          callBack: (number) {
            if (number <=
                Provider.of<WordData>(context, listen: false).list.length) {
              if (number <=
                  Provider.of<WordData>(context, listen: false)
                      .howManyExamples()) {
                setState(() {
                  selectedNumber = number;
                });
              } else {
                Fluttertoast.showToast(
                    gravity: ToastGravity.SNACKBAR,
                    msg:
                        'There is just ${Provider.of<WordData>(context, listen: false).howManyExamples()} words have examples',
                    fontSize: 15,
                    textColor: kPimaryColor,
                    backgroundColor: Colors.white);
              }
            } else {
              Fluttertoast.showToast(
                  gravity: ToastGravity.SNACKBAR,
                  msg:
                      'You can\'t choose number bigger than ${Provider.of<WordData>(context, listen: false).list.length}',
                  fontSize: 15,
                  textColor: kPimaryColor,
                  backgroundColor: Colors.white);
            }
          });
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }

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
                  'Examples',
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            children: col(),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40, bottom: 30),
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
                                if (selectedNumber <=
                                        wordProvider.list.length &&
                                    selectedNumber != 0) {
                                  pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.linear);
                                  random = [];
                                  for (int i = 0; i < selectedNumber; i++) {
                                    int n = Random()
                                        .nextInt(wordProvider.examples.length);
                                    while (random.contains(n) ||
                                        wordProvider
                                            .examples[n].example.isEmpty) {
                                      n = Random().nextInt(
                                          wordProvider.examples.length);
                                    }
                                    random.add(n);
                                  }
                                }
                                wordProvider.setRaandom(random);
                                // wordProvider.howmaenyex();
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
                            ),
                          ],
                        ),
                      ],
                    ),
                    ExampleTrainingView(pageController: pageController),
                    ExampleResultScreen(pageController: pageController),
                  ],
                ),
              ),
            ),
          ],
        )),
      );
    });
  }
}
