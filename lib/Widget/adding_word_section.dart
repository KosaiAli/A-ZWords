import 'package:azwords/Function/worddata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingWordSection extends StatefulWidget {
  const AddingWordSection({
    Key? key,
    required this.first,
    required this.second,
    required this.fn1,
    required this.tce1,
    required this.wordWriting,
  }) : super(key: key);

  final bool first;
  final bool second;
  final TextEditingController tce1;
  final FocusNode fn1;
  final Function wordWriting;
  @override
  State<AddingWordSection> createState() => _AddingWordSectionState();
}

class _AddingWordSectionState extends State<AddingWordSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: AnimatedOpacity(
          opacity: wordProvider.adding ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: TextField(
            enabled: !wordProvider.adding,
            onSubmitted: (value) {
              setState(() {
                // widget.first = false;
                // widget.second = false;
              });
            },
            controller: widget.tce1,
            focusNode: widget.fn1,
            onTap: () {
              setState(() {
                // widget.first = true;
                // widget.second = false;
              });
            },
            onChanged: (value) => widget.wordWriting(value),
            cursorHeight: 20,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              labelText: 'Write your word',
              labelStyle: TextStyle(
                  color: widget.first ? Colors.blue : Colors.white,
                  fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 22, 151, 202),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
