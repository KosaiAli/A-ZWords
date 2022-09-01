import 'package:flutter/material.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
      primaryColor: Colors.black,
      cardColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 8, 13, 29),
      shadowColor: Colors.white,
      canvasColor: Colors.blue[100]);
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.blue.shade900.withOpacity(0.1),
    canvasColor: Colors.blue.shade200,
    backgroundColor: const Color.fromARGB(255, 8, 10, 17),
    cardColor: const Color.fromARGB(255, 41, 44, 58),
  );
}
