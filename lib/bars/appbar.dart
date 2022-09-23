import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Widget/online_adding_section.dart';
import 'package:azwords/Widget/search_button.dart';
import 'package:azwords/constant.dart';
import 'package:azwords/themebuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBar extends StatefulWidget {
  const AppBar({Key? key}) : super(key: key);

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> with SingleTickerProviderStateMixin {
  DateTime timeBackpressed = DateTime.now();
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    loadData();
  }

  void loadData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('themeMode') != null) {
      if (sharedPreferences.getString('themeMode') == 'dark') {
        await animationController.forward().then(
          (value) {
            animationController.addStatusListener(
              (status) {
                if (status == AnimationStatus.completed) {
                  ThemeBuilder.of(context)?.changeTheme();
                } else if (status == AnimationStatus.dismissed) {
                  ThemeBuilder.of(context)?.changeTheme();
                }
              },
            );
          },
        );
        return;
      }
      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          ThemeBuilder.of(context)?.changeTheme();
        } else if (status == AnimationStatus.dismissed) {
          ThemeBuilder.of(context)?.changeTheme();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProider, child) => WillPopScope(
        onWillPop: () async {
          if (wordProider.adding) {
            wordProider.setAdd(false);
            setState(() {});
            return false;
          }
          final difference = DateTime.now().difference(timeBackpressed);
          final isExitWarning =
              difference >= const Duration(milliseconds: 2000);

          timeBackpressed = DateTime.now();

          if (isExitWarning) {
            Fluttertoast.showToast(
                gravity: ToastGravity.SNACKBAR,
                msg: 'Press back again to exit',
                fontSize: 16,
                textColor: kPimaryColor,
                backgroundColor: Colors.white);
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: AnimatedContainer(
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 600),
          height: wordProider.adding
              ? MediaQuery.of(context).size.height * 0.90
              : MediaQuery.of(context).size.height * 0.30,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.elliptical(60, 60),
              bottomLeft: Radius.elliptical(60, 60),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 25,
                      child: Icon(Icons.list, color: kPimaryColor, size: 30),
                    ),
                    GestureDetector(
                      onTap: () {
                        animationController.forward();
                        if (animationController.isCompleted) {
                          animationController.reverse();
                        }
                      },
                      child: Lottie.asset(
                        'Assets/Animation/switch button.zip',
                        width: 65,
                        controller: animationController,
                        fit: BoxFit.fill,
                        height: 45,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'A-Z Words',
                  style: TextStyle(
                    fontFamily: 'LuckiestGuy',
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: LengthInfo(),
              ),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: IgnorePointer(
                                ignoring: !wordProider.adding,
                                child: const OnlineAddingSection()),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: SearchBar(
                            size: MediaQuery.of(context).size,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LengthInfo extends StatelessWidget {
  const LengthInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('words')
            .snapshots(),
        builder: (context, snapshot) {
          return Consumer<WordData>(
            builder: (context, wordProvider, child) => Text(
              wordProvider.selecting
                  ? '${wordProvider.selectedwords.length} selected'
                  : '${snapshot.data?.docs.length} word',
              style: TextStyle(
                  color: wordProvider.selecting ? Colors.blue : Colors.white,
                  fontSize: 16,
                  fontWeight: wordProvider.selecting
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          );
        });
  }
}
