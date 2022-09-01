import 'package:azwords/Function/worddata.dart';
import 'package:azwords/themebuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortType extends StatelessWidget {
  const SortType(
      {Key? key, required this.text, required this.index, this.image})
      : super(key: key);

  final String text;
  final int index;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Provider.of<WordData>(context, listen: false).setdisplaySelected(index);
        if (text == 'a-z') {
          // await Provider.of<WordData>(context, listen: false).sortAtoZ();
          Provider.of<WordData>(context, listen: false).setSelected(index);
        } else if (text == 'z-a') {
          Provider.of<WordData>(context, listen: false).setSelected(index);
        } else if (text == ' favourite') {
          // await Provider.of<WordData>(context, listen: false).sorFavourite();
          Provider.of<WordData>(context, listen: false).setSelected(index);
        } else if (text == 'normal') {
          Provider.of<WordData>(context, listen: false).setSelected(index);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(35),
            ),
            color: index == Provider.of<WordData>(context).displayselected
                ? Colors.blue[100]
                : ThemeBuilder.of(context)?.themeMode == ThemeMode.dark
                    ? Theme.of(context).backgroundColor
                    : Colors.white,
            border: Border.all(
                color: index == Provider.of<WordData>(context).displayselected
                    ? Colors.blue.shade200
                    : Colors.black)),
        child: Row(
          children: [
            if (image != null)
              Image(
                image: AssetImage('Assets/Images/$image.png'),
                height: 20,
                width: 20,
              )
            else
              const Text(''),
            Text(
              text,
              style: TextStyle(
                color: index == Provider.of<WordData>(context).displayselected
                    ? Colors.black
                    : Theme.of(context).textTheme.subtitle1?.color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
