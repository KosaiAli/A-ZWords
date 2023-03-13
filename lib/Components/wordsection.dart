import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/wordscreen.dart';
import 'package:azwords/themebuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordSection extends StatefulWidget {
  const WordSection({Key? key, required this.word}) : super(key: key);
  final Word word;
  @override
  State<WordSection> createState() => _WordSectionState();
}

class _WordSectionState extends State<WordSection>
    with TickerProviderStateMixin {
  bool selected = false;
  late Animation animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOutCirc))
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => Transform.scale(
        scale: animation.value,
        child: GestureDetector(
          onTap: () {
            if (wordProvider.selecting) {
              setState(() {
                selected = !selected;
              });
              if (selected) {
                wordProvider.addSelected(widget.word.word);
              }
              if (!selected) {
                wordProvider.removeselected(widget.word.word);
                if (wordProvider.selectedwords.isEmpty) {
                  wordProvider.setselecting(false);
                }
              }
            } else {
              showModalBottomSheet(
                backgroundColor: const Color(0x00737373),
                context: context,
                builder: (context) => Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35))),
                  child: WordScreen(word: widget.word),
                ),
              );
            }
          },
          onLongPress: () {
            if (!wordProvider.selecting) {
              wordProvider.setselecting(true);
              wordProvider.addSelected(widget.word.word);
              setState(() {
                selected = true;
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(
                horizontal:
                    wordProvider.selectedwords.contains(widget.word.word) &&
                            wordProvider.selecting
                        ? 50
                        : 30,
                vertical: 10),
            height: 100,
            decoration: BoxDecoration(
                color: wordProvider.selectedwords.contains(widget.word.word) &&
                        wordProvider.selecting
                    ? Colors.blue[200]
                    : Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow:
                    ThemeBuilder.of(context)!.themeMode == ThemeMode.light
                        ? [
                            BoxShadow(
                              color: const Color(0xFF132C33).withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Text(
                                widget.word.word,
                                style: const TextStyle(
                                    height: 1.2,
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        widget.word.fav
                            ? Container(
                                height: 35,
                                width: 30,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: Colors.blue,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              )
                            : const Text(''),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Meaning: ',
                        style: TextStyle(
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.word.meaning[0]['definitions'][0]['definition']
                            .toString(),
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(height: 1.2, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
