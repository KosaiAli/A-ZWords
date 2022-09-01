import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBuilder extends StatefulWidget {
  const ThemeBuilder({Key? key, required this.builder}) : super(key: key);

  final Widget Function(BuildContext context, ThemeMode thememode) builder;

  @override
  State<ThemeBuilder> createState() => ThemeBuilderState();

  static ThemeBuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeBuilderState>();
  }
}

class ThemeBuilderState extends State<ThemeBuilder> {
  late SharedPreferences sharedPreferences;
  ThemeMode themeMode = ThemeMode.light;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
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
    setState(() {});
  }

  void changeTheme() {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
      sharedPreferences.setString('themeMode', 'dark');
    } else {
      themeMode = ThemeMode.light;
      sharedPreferences.setString('themeMode', 'light');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, themeMode);
  }
}
