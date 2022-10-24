import 'dart:math';

import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/Matching_Screens_Views/results_view.dart';
import 'package:azwords/Screens/Matching_Screens_Views/training_view.dart';
import 'package:azwords/constant.dart';
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: GridView.builder(
                              shrinkWrap: true,
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
