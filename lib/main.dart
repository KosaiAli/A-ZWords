import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/wordscreen.dart';
import 'package:azwords/Widget/buttons.dart';
import 'package:azwords/Widget/image_provider.dart';
import 'package:azwords/bars/appbar.dart' as appbar;
import 'package:azwords/bars/bottombar.dart';
import 'package:azwords/bars/type_sorting_bar.dart';
import 'package:azwords/bars/wordlist.dart';
import 'package:azwords/theme.dart';
import 'package:azwords/themebuilder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'Screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: thememode,
        home: FirebaseAuth.instance.currentUser != null
            ? const HomeScreen()
            : const LogInScreen(),
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
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('Assets/Images/background.jpg'),
                  opacity: 0.1,
                  fit: MediaQuery.of(context).size.width <
                          MediaQuery.of(context).size.height
                      ? BoxFit.fill
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
                  panel: const ImagesProv(),
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
