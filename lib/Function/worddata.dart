import 'package:azwords/Function/word.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordData extends ChangeNotifier {
  List<dynamic> words = [];
  List<String> selectedwords = [];
  List<dynamic> searchedWords = [];
  bool adding = false;
  bool scrolling = false;
  bool selecting = false;
  bool explinationBoxShowed = false;
  bool explinationContentShowed = false;
  bool explinationDone = false;
  bool testing = false;
  bool connected = false;

  int displayselected = 1;
  int selected = 1;
  int barButtonSelected = 1;

  late SharedPreferences sharedPreferences;
  ThemeMode themeMode = ThemeMode.light;

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
    // Future.delayed(Duration(milliseconds: 500), () => notifyListeners());
  }

  void setScrolling(bool value) {
    scrolling = value;
    notifyListeners();
  }

  void setTesting(bool value) {
    testing = value;
    notifyListeners();
  }

  void setselecting(bool b) {
    selecting = b;
    notifyListeners();
  }

  void setFav(Word index) {
    words[isFav2(index)].fav = !words[isFav2(index)].fav;
    // if (selected == 4) sorFavourite();
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

  void addWord(String w, String m, DateTime d) {
    // Word word = Word(w, m, d);
    // words.add(word);
    notifyListeners();
  }

  void setAdd(bool add) {
    adding = add;
    notifyListeners();
  }

  void setShowed(bool e) {
    explinationBoxShowed = e;

    notifyListeners();
  }

  void setContentShowed(bool e) {
    explinationContentShowed = e;
    notifyListeners();
  }

  void setExDone() {
    explinationDone = true;
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

  // bool isFav(Word index) {
  //   if (selected == 1) {
  //     for (int i = 0; i < words.length; i++) {
  //       if (index.word == words[i].word && words[i].fav) {
  //         return true;
  //       }
  //     }
  //   } else {
  //     for (int i = 0; i < temp.length; i++) {
  //       if (index.word == temp[i].word && temp[i].fav) return true;
  //     }
  //   }
  //   return false;
  // }
  List<Word> search(String searchWord) {
    List<String> founded = [];
    List<Word> finals = [];
    for (var element in words) {
      if (searchWord == element.id) {
        founded.add(searchWord);
        finals.add(Word(
            element.id, element.data()['meanings'], element.data()['fav']));
      }
      for (int i = 0; i < searchWord.length; i++) {
        if (element.id
                .toString()
                .contains(searchWord.substring(0, searchWord.length)) &&
            !founded.contains(element.id)) {
          founded.add(element.id);
          finals.add(Word(
              element.id, element.data()['meanings'], element.data()['fav']));
        }
      }
      if (searchWord.characters
              .every((char) => element.id.toString().contains(char)) &&
          !founded.contains(element.id)) {
        finals.add(Word(
            element.id, element.data()['meanings'], element.data()['fav']));
      }
    }

    return finals;
  }

  int isFav2(Word index) {
    for (int i = 0; i < words.length; i++) {
      if (index.word == words[i].word) {
        return i;
      }
    }
    return -1;
  }
}
