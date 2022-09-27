import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/Matching_Screens_Views/matching_screen.dart';
import 'package:azwords/animation.dart';
import 'package:azwords/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../Function/word.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    List<Word> words = [];
    int n = 0;
    Provider.of<WordData>(context, listen: false).words.forEach((element) {
      if (element.data()['photoUrl'] != null) {
        n++;
      }
      words.add(Word(element.id, element.data()['meanings'],
          element.data()['fav'], element.data()['photoUrl']));
    });
    Provider.of<WordData>(context, listen: false).sethowmaynphotos(n);
    Provider.of<WordData>(context, listen: false).initList(words);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return Expanded(
          child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              children: [
            GestureDetector(
              onTap: () {
                if (wordProvider.list.length >= 5) {
                  Navigator.push(
                      context, SliderNavigator(page: const MatchingScreen()));
                } else {
                  Fluttertoast.showToast(
                      gravity: ToastGravity.SNACKBAR,
                      msg: 'No enough words, Add more before you try again..',
                      fontSize: 14,
                      textColor: kPimaryColor,
                      backgroundColor: Colors.white);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 12),
                        blurRadius: 16)
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Images/research.png',
                      color: Colors.blue,
                      height: 75,
                      width: 75,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const Text(
                      'Matching',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.red,
              margin: const EdgeInsets.all(20),
            ),
          ]));
    });
  }
}
