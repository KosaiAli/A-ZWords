import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Word {
  final String word;
  List<dynamic> meaning;
  bool fav = false;
  String? photoURL;

  Word(this.word, this.meaning, this.fav, this.photoURL);

  List<Widget> getdefinations(int index) {
    List<dynamic> definitation = meaning[index]['definitions'];

    final lis = definitation.map((e) {
      int index2 = definitation.indexOf(e);
      String example = '';
      if (meaning[index]['definitions'][index2]['example'] != null) {
        example = meaning[index]['definitions'][index2]['example'];
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${index2 + 1}- ${meaning[index]['definitions'][index2]['definition']}',
                      style: const TextStyle(height: 1.2, fontSize: 14),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        String url;
                        if (example != '') {
                          url =
                              'https://translate.google.com/?sl=en&tl=ar&text=${meaning[index]['definitions'][index2]['definition']}\nexample: $example&op=translate';
                        } else {
                          url =
                              'https://translate.google.com/?sl=en&tl=ar&text=${meaning[index]['definitions'][index2]['definition']}&op=translate';
                        }
                        if (await url_launcher.canLaunchUrl(Uri.parse(url))) {
                          url_launcher.launchUrl(Uri.parse(url));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.translate,
                          size: 20,
                        ),
                      ))
                ],
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
    List meanings = meaning;

    final m = meanings.map((e) {
      final index = meanings.indexOf(e);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${meaning[index]['partOfSpeech']}:',
              style: const TextStyle(height: 1.2, fontSize: 18),
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
}
