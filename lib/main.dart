import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/wordscreen.dart';
import 'package:azwords/Components/Buttons/buttons.dart';
import 'package:azwords/Components/image_provider.dart';
import 'package:azwords/bars/appbar.dart' as appbar;
import 'package:azwords/bars/bottombar.dart';
import 'package:azwords/bars/sorting_type_bar.dart';
import 'package:azwords/bars/wordlist.dart';
import 'package:azwords/themebuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:workmanager/workmanager.dart';

import 'Screens/login_screen.dart';
import 'constant.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await Firebase.initializeApp();
    String? lastTime;
    DateTime? dateTime;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Trainings')
          .doc('Examples')
          .collection('value')
          .get()
          .then((value) => lastTime = value.docs.last.id);

      dateTime = DateTime.parse(lastTime.toString());
    } catch (e) {
      dateTime = null;
    }
    if (dateTime?.month == DateTime.now().month &&
        dateTime?.day == DateTime.now().day) {
      return Future.value(true);
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Trainings')
          .doc('Examples')
          .collection('value')
          .doc(DateTime.now().toString())
          .set({'result': <String, bool>{}}).then((value) {
        Fluttertoast.showToast(
            gravity: ToastGravity.SNACKBAR,
            msg: 'Data created',
            fontSize: 16,
            textColor: kPimaryColor,
            backgroundColor: Colors.white);
      });
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Workmanager().initialize(callbackDispatcher);
  // await Workmanager().registerPeriodicTask('test_worker1', 'test_workerTask',
  //     frequency: const Duration(minutes: 15),
  //     constraints: Constraints(networkType: NetworkType.connected));
  await Firebase.initializeApp();
  BuildContext context;
  runApp(
    ChangeNotifierProvider(
        create: (context) => WordData(), child: const Main()),
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    Provider.of<WordData>(context, listen: false).setThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, thememode) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Cairo').copyWith(
              primaryColor: Colors.white,
              cardColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 8, 13, 29),
              shadowColor: const Color(0xFF132C33).withOpacity(0.3),
              canvasColor: Colors.blue[100]),
          darkTheme: ThemeData(fontFamily: 'Cairo').copyWith(
            primaryColor: Colors.blueGrey,
            scaffoldBackgroundColor: Colors.blue.shade900.withOpacity(0.1),
            canvasColor: Colors.blue.shade200,
            backgroundColor: const Color.fromARGB(255, 8, 10, 17),
            cardColor: const Color.fromARGB(255, 41, 44, 58),
          ),
          themeMode: thememode,
          home: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Provider.of<WordData>(context, listen: false).load().then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      });
    } else {
      await Future.delayed(Duration(seconds: 2));

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogInScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Loading'),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('assets/Images/background.jpg'),
                  opacity: 0.1,
                  fit: MediaQuery.of(context).size.width <
                          MediaQuery.of(context).size.height
                      ? BoxFit.contain
                      : BoxFit.fitWidth),
            ),
            child: Stack(
              children: [
                Column(
                  children: const [
                    appbar.AppBar(),
                    SortingTypeBar(),
                    WordsList(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        BottomBar(size: MediaQuery.of(context).size),
                        Center(
                          child: AnimatedSlide(
                            curve: Curves.easeOutExpo,
                            duration: const Duration(milliseconds: 600),
                            offset: Offset(
                                wordProvider.scrolling
                                    ? MediaQuery.of(context).size.width / 146
                                    : 0,
                                -0.25),
                            child: const AddButton(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                 
                SlidingUpPanel(
                  onPanelClosed: () {
                    wordProvider.setonlineSearchedWord(null);
                    if (!wordProvider.adding) {
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
                              word: wordProvider.deitingOrAddingWord),
                        ),
                      );
                    }
                  },
                  minHeight: 0.0,
                  maxHeight: MediaQuery.of(context).size.height * 0.90,
                  controller: wordProvider.panelController,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  // ignore: prefer_const_constructors
                  panel: ImagesProv(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextScreen extends StatelessWidget {
  const TextScreen({Key? key, required this.words}) : super(key: key);
  final List<Word> words;
  @override
  Widget build(BuildContext context) {
    if (words.length < 2) {
      return const Center(
        child: Text(
          'There is no enough words\n try to add more',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }
    return const Text("bla bla bla");
  }
}
