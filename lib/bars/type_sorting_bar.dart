import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Widget/sorting_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortingTypeBar extends StatelessWidget {
  const SortingTypeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, worddata, child) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: worddata.adding ||
                  worddata.scrolling ||
                  worddata.barButtonSelected == 2
              ? 0
              : 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: worddata.scrolling ? 0 : 1,
                  child: const SortType(text: 'a-z', index: 1)),
              AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: worddata.scrolling ? 0 : 1,
                  child: const SortType(text: 'z-a', index: 2)),
              AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: worddata.scrolling ? 0 : 1,
                  child: const SortType(
                      image: 'heart', text: ' favourite', index: 3)),
            ],
          ),
        ),
      ),
    );
  }
}
