import 'package:azwords/Function/worddata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key, required this.saveWord}) : super(key: key);

  final Function saveWord;
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => AnimatedOpacity(
        opacity: wordProvider.adding ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: GestureDetector(
          onTap: () async {
            await saveWord();
          },
          child: Container(
            width: 170,
            height: 70,
            decoration: BoxDecoration(
              boxShadow: [
                !wordProvider.explinationBoxShowed
                    ? const BoxShadow(
                        color: Colors.blue,
                        blurRadius: 10,
                        offset: Offset(0, -2))
                    : BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 0,
                      ),
                !wordProvider.explinationBoxShowed
                    ? const BoxShadow(
                        color: Colors.white,
                        blurRadius: 2,
                        offset: Offset(0, -2))
                    : BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 0,
                      ),
              ],
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.elliptical(60, 60),
                topLeft: Radius.elliptical(60, 60),
              ),
            ),
            child: const Center(
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16, shadows: [
                  Shadow(
                    blurRadius: 2,
                    offset: Offset(0, 2),
                    color: Colors.blue,
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
