import 'package:azwords/Function/worddata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class UpButton extends StatefulWidget {
  const UpButton({
    Key? key,
  }) : super(key: key);

  @override
  State<UpButton> createState() => _UpButtonState();
}

class _UpButtonState extends State<UpButton> {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  @override
  void initState() {
    super.initState();

    var androidinit = const AndroidInitializationSettings('ic_launcher');
    var initializationsetting = InitializationSettings(android: androidinit);
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    localNotificationsPlugin.initialize(initializationsetting);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => AnimatedScale(
        duration: const Duration(milliseconds: 500),
        scale: !wordProvider.adding && wordProvider.scrolling ? 1 : 0,
        curve: Curves.easeInOutExpo,
        child: Container(
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(35)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 0.5,
                spreadRadius: 0.1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: RawMaterialButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              child: const Icon(
                Icons.arrow_upward_sharp,
                size: 20,
                color: Colors.blue,
              )),
        ),
      ),
    );
  }
}

class AddButton extends StatefulWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);
  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  final MethodChannel platform = const MethodChannel('sendData');
  late bool isDone = false;
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Future<void> fun() async {
  //   try {
  //     var b = await platform.invokeMethod('fun');
  //     print('result :' + b.toString());
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: wordProvider.adding ? 0 : 1,
        child: GestureDetector(
            onTap: () async {
              if (!wordProvider.selecting) {
                wordProvider.setAdd(true);
              } else {
                wordProvider.setselecting(false);
                for (var word in wordProvider.selectedwords) {
                  _fireStore
                      .collection('users')
                      .doc(_auth.currentUser?.uid)
                      .collection('words')
                      .doc(word)
                      .delete();
                }
                wordProvider.removeSelectedAll();
                if (wordProvider.words.length <= 5) {
                  Provider.of<WordData>(context, listen: false)
                      .setScrolling(false);
                }
              }
            },
            child: CircleAvatar(
                maxRadius: MediaQuery.of(context).size.height >
                        MediaQuery.of(context).size.width
                    ? MediaQuery.of(context).size.width < 450
                        ? MediaQuery.of(context).size.width / 14
                        : MediaQuery.of(context).size.width / 18
                    : MediaQuery.of(context).size.width / 24,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                child: Icon(!wordProvider.selecting
                    ? Icons.add
                    : Icons.delete_rounded))),
      ),
    );
  }
}
