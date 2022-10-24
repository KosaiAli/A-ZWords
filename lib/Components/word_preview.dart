import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/themebuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordPreview extends StatefulWidget {
  const WordPreview({Key? key, required this.jsoncode, required this.word})
      : super(key: key);

  final dynamic jsoncode;
  final Word word;
  @override
  State<WordPreview> createState() => _WordPreviewState();
}

class _WordPreviewState extends State<WordPreview> {
  String def = '';
  List<dynamic> meanings = [];
  List<Widget> getdefinations(int index) {
    List<dynamic> definitation =
        widget.jsoncode[0]['meanings'][index]['definitions'];

    final lis = definitation.map((e) {
      int index2 = definitation.indexOf(e);
      String example = '';
      if (widget.jsoncode[0]['meanings'][index]['definitions'][index2]
              ['example'] !=
          null) {
        example = widget.jsoncode[0]['meanings'][index]['definitions'][index2]
            ['example'];
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                '${index2 + 1}- ${widget.jsoncode[0]['meanings'][index]['definitions'][index2]['definition']}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (example != '')
              Text(
                'example : $example',
              ),
          ],
        ),
      );
    }).toList();
    return lis;
  }

  List<Widget> getMeanings() {
    meanings = widget.jsoncode[0]['meanings'];

    final m = meanings.map((e) {
      final index = meanings.indexOf(e);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.jsoncode[0]['meanings'][index]['partOfSpeech']}:',
              style: const TextStyle(fontSize: 18),
            ),
            Column(
              children: getdefinations(index),
            )
          ],
        ),
      );
    }).toList();

    return m;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 40, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.jsoncode[0]['word'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      height: 1.2,
                      color: Colors.blue,
                      letterSpacing: 0.5,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      wordProvider
                          .setonlineSearchedWord(widget.jsoncode[0]['word']);
                      wordProvider.panelController.open();
                      wordProvider.setjsoncode(widget.jsoncode);
                      wordProvider.setmeanings(meanings);
                    },
                    fillColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                    constraints:
                        const BoxConstraints.expand(height: 40, width: 40),
                    child: Icon(Icons.add,
                        color: ThemeBuilder.of(context)?.themeMode ==
                                ThemeMode.light
                            ? Colors.white
                            : Colors.black),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Meaning:',
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 0.4),
                    ),
                  ),
                  Column(
                    children: getMeanings(),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
