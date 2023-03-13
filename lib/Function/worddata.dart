import 'package:azwords/Function/example.dart';
import 'package:azwords/Function/statement.dart';
import 'package:azwords/Function/word.dart';
import 'package:azwords/Models/user.dart' as users;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WordData extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  ThemeMode themeMode = ThemeMode.light;
  PanelController panelController = PanelController();

  List<dynamic> words = [];
  List<String> selectedwords = [];
  List<dynamic> searchedWords = [];
  List<Word> list = [];
  List<Example> examples = [];
  List<int> random = [];

  Map<String, bool> results = {};
  Map<String, bool> exResults = {};

  bool adding = false;
  bool scrolling = false;
  bool selecting = false;
  bool explinationBoxShowed = false;
  bool explinationContentShowed = false;
  bool explinationDone = false;
  bool connected = false;

  int displayselected = 1;
  int selected = 1;
  int barButtonSelected = 1;
  int howmaynphotos = 0;

  late Statement statement;
  late Word deitingOrAddingWord;
  late dynamic jsoncode;
  late List<dynamic> meanings;
  late AnimationController animationController;
  late SharedPreferences sharedPreferences;

  String? onlineSearchedWord;
  List<Node?> nodes = [];

  void initAnimationController(TickerProvider vsync) {
    animationController =
        AnimationController(vsync: vsync, duration: const Duration(seconds: 1));
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late users.User user;
  Future<void> load() async {
    late QuerySnapshot<Map<String, dynamic>> res;
    late QuerySnapshot<Map<String, dynamic>> res2;
    String? imagePic;
    late String name;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Trainings')
        .doc('Examples')
        .collection('value')
        .get()
        .then((value) {
      res = value;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Trainings')
        .doc('Matching')
        .collection('value')
        .get()
        .then((value) {
      res2 = value;
    });
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((snapShot) {
      imagePic = snapShot.data()?['profilePic'];
    });
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((snapShot) {
      name = snapShot.data()?['name'];
    });
    List word;
    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('words')
        .get()
        .then((snapshot) {
      words = snapshot.docs.reversed.toList();
    });
    user = users.User(
        name: name, res: res, res2: res2, profilePic: imagePic, words: words);
    notifyListeners();
  }

  Future<void> updateWords() async {
    var word;
    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('words')
        .get()
        .then((snapshot) {
      words = snapshot.docs.reversed.toList();
    });
    user.words = words;
    notifyListeners();
  }

  int howManyExamples() {
    examples = [];
    for (int i = 0; i < list.length; i++) {
      examples.add(Example(word: list[i].word, example: []));
      for (var e in list[i].meaning) {
        int index = list[i].meaning.indexOf(e);
        List<dynamic> definitions = list[i].meaning[index]['definitions'];
        for (var def in definitions) {
          int index2 = definitions.indexOf(def);
          if (list[i].meaning[index]['definitions'][index2]['example'] !=
              null) {
            examples[i]
                .example
                .add(list[i].meaning[index]['definitions'][index2]['example']);
          }
        }
      }
    }
    notifyListeners();
    int n = 0;
    for (var element in examples) {
      if (element.example.isNotEmpty) {
        n++;
      }
    }
    return n;
  }

  int howmaenyex() {
    int n = 0;
    for (int i = 0; i < random.length; i++) {
      n += examples[random[i]].example.length;
    }
    return n;
  }

  void initExamples() {
    exResults = {};
    nodes = [];
    statement = Statement();
    statement.head = Node(word: list[random[0]].word);
    statement.temp = statement.head;

    for (int i = 1; i < random.length; i++) {
      statement.temp?.next = Node(word: list[random[i]].word);
      statement.temp = statement.temp?.next;
    }
    statement.temp = statement.head;
    for (int i = 0; i < random.length; i++) {
      List<String> defs = [];
      for (var e in list[random[i]].meaning) {
        int index = list[random[i]].meaning.indexOf(e);
        List<dynamic> definitions =
            list[random[i]].meaning[index]['definitions'];

        for (var def in definitions) {
          int index2 = definitions.indexOf(def);
          if (list[random[i]].meaning[index]['definitions'][index2]
                  ['example'] !=
              null) {
            defs.add(list[random[i]].meaning[index]['definitions'][index2]
                ['example']);
          }
        }
      }
      if (defs.isNotEmpty) {
        statement.temp?.head = Sentence(sentence: defs[0]);
        statement.temp?.temp = statement.temp?.head;

        for (int j = 1; j < defs.length; j++) {
          statement.temp?.temp?.next = Sentence(sentence: defs[j]);
          statement.temp?.temp = statement.temp?.temp?.next;
        }
      }
      statement.temp = statement.temp?.next;
    }
    statement.temp = statement.head;
    while (statement.temp != null) {
      nodes.add(statement.temp);
      statement.temp = statement.temp?.next;
    }

    statement.temp = statement.head;
    while (statement.temp != null) {
      statement.temp?.temp = statement.temp?.head;
      statement.temp = statement.temp?.next;
    }
    statement.temp = statement.head;
  }

  void setRaandom(List<int> value) {
    random = value;
    notifyListeners();
  }

  int howManyCorrect() {
    int n = 0;
    results.forEach((key, value) {
      if (value == true) {
        n++;
      }
    });
    return n;
  }

  int howManyExamplesCorrect() {
    int n = 0;
    exResults.forEach((key, value) {
      if (value == true) {
        n++;
      }
    });
    return n;
  }

  void sethowmaynphotos(int value) {
    howmaynphotos = value;
  }

  void initList(List<Word> value) {
    list = value;
  }

  void setdeitingOrAddingWord(Word value) {
    deitingOrAddingWord = value;
    notifyListeners();
  }

  void setonlineSearchedWord(String? word) {
    onlineSearchedWord = word;
    notifyListeners();
  }

  void setjsoncode(dynamic value) {
    jsoncode = value;
    notifyListeners();
  }

  void setmeanings(List<dynamic> value) {
    meanings = value;
    notifyListeners();
  }

  void setListner() {
    scrollController.addListener(() {
      if (words.length > 4) {
        setScrolling(scrollController.offset > 0);
      } else {
        setScrolling(false);
      }
    });
  }

  Future<void> setThemeMode() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('themeMode') != null) {
      if (sharedPreferences.getString('themeMode') == 'light') {
        themeMode = ThemeMode.light;
      } else {
        themeMode = ThemeMode.dark;
      }
    } else {
      themeMode = ThemeMode.light;
      sharedPreferences.setString('themeMode', 'light');
    }
  }

  Future hasInternet() async {
    connected = await InternetConnectionChecker().hasConnection;
    notifyListeners();
  }

  void setWords(List<dynamic> words) {
    this.words = words;
  }

  void setScrolling(bool value) {
    scrolling = value;
    notifyListeners();
  }

  void setselecting(bool b) {
    selecting = b;
    notifyListeners();
  }

  void setdisplaySelected(int index) {
    displayselected = index;
    notifyListeners();
  }

  void setSelected(int index) {
    selected = index;
    notifyListeners();
  }

  void setBarButton(int index) {
    barButtonSelected = index;
    notifyListeners();
  }

  void setAddingValue(bool add) {
    adding = add;
    notifyListeners();
  }

  void addSelected(String index) {
    if (!selectedwords.contains(index)) {
      selectedwords.add(index);
    }
    notifyListeners();
  }

  void removeSelectedAll() {
    selectedwords.removeRange(0, selectedwords.length);

    selecting = false;
    notifyListeners();
  }

  void removeselected(String index) {
    selectedwords.remove(index);

    notifyListeners();
  }

  List<Word> search(String searchWord) {
    List<String> founded = [];
    List<Word> finals = [];
    if (searchWord == '') {
      return [];
    }
    for (var element in words) {
      if (searchWord == element.id) {
        founded.add(searchWord);
        finals.add(Word(element.id, element.data()['meanings'],
            element.data()['fav'], element.data()['photoUrl']));
      }
      for (int i = 0; i < searchWord.length; i++) {
        if (element.id
                .toString()
                .contains(searchWord.substring(0, searchWord.length)) &&
            !founded.contains(element.id)) {
          founded.add(element.id);
          finals.add(Word(element.id, element.data()['meanings'],
              element.data()['fav'], element.data()['photoUrl']));
        }
      }
      if (searchWord.characters
              .every((char) => element.id.toString().contains(char)) &&
          !founded.contains(element.id)) {
        finals.add(Word(element.id, element.data()['meanings'],
            element.data()['fav'], element.data()['photoUrl']));
      }
    }

    return finals;
  }
}
