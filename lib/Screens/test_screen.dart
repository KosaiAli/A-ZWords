import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/Expamles_Screen_Views/example_test_screen.dart';
import 'package:azwords/Screens/Matching_Screens_Views/matching_screen.dart';
import 'package:azwords/animation.dart';
import 'package:azwords/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            children: const [
              TestTypeCard(
                word: 'Matching',
                photo: 'assets/Images/puzzle.png',
                target: MatchingScreen(),
              ),
              TestTypeCard(
                word: 'Examples',
                photo: 'assets/Images/reference(1).png',
                target: ExampleTestScreen(),
              )
            ]),
      ));
    });
  }
}

class TestTypeCard extends StatelessWidget {
  const TestTypeCard({
    Key? key,
    required this.word,
    required this.photo,
    required this.target,
  }) : super(key: key);
  final String word;
  final String photo;
  final Widget target;
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) {
        return GestureDetector(
          onTap: () async {
            late QueryDocumentSnapshot<Map<String, dynamic>> lastTime;
            DateTime? dateTime;
            Fluttertoast.showToast(
                gravity: ToastGravity.SNACKBAR,
                msg: 'Please wait!',
                fontSize: 14,
                toastLength: Toast.LENGTH_SHORT,
                textColor: kPimaryColor,
                backgroundColor: Colors.white);
            try {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('Trainings')
                  .doc(word)
                  .collection('value')
                  .get()
                  .then((value) => lastTime = value.docs.last);

              dateTime = DateTime.parse(lastTime.id.toString());
            } catch (e) {
              dateTime = null;
            }
            if (wordProvider.list.length >= 3) {
              if (dateTime?.month == DateTime.now().month &&
                  dateTime?.day == DateTime.now().day &&
                  (lastTime.data()['result'] as Map).isNotEmpty) {
                Fluttertoast.showToast(
                    gravity: ToastGravity.SNACKBAR,
                    msg:
                        'You have done your training for today..\n try again tomorrow',
                    fontSize: 14,
                    textColor: kPimaryColor,
                    backgroundColor: Colors.white);
              } else {
                // ignore: use_build_context_synchronously
                Navigator.push(context, SliderNavigator(page: target));
              }
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
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 8),
                    blurRadius: 14)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  photo,
                  color: Colors.blue,
                  height: 75,
                  width: 75,
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  word,
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
