// // ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:azwords/Function/worddata.dart';
// import 'package:azwords/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Tips extends StatefulWidget {
//   Tips(
//       {Key? key,
//       required this.size,
//       required this.fn2,
//       required this.gotit,
//       required this.explinationBoxShowed,
//       required this.explinationDone,
//       required this.explinationContentShowed,
//       required this.load})
//       : super(key: key);

//   final Size size;
//   final FocusNode fn2;
//   final Function gotit;
//   final bool explinationBoxShowed;
//   final bool explinationDone;
//   final bool explinationContentShowed;
//   final Function load;
//   @override
//   State<Tips> createState() => _TipsState();
// }

// class _TipsState extends State<Tips> {
//   late SharedPreferences sharedPreferences;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WordData>(
//       builder: (context, WordData, child) => AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//         height:
//             widget.explinationBoxShowed && !widget.explinationDone ? 270 : 0,
//         margin: widget.explinationBoxShowed && !widget.explinationDone
//             ? const EdgeInsets.symmetric(horizontal: 30)
//             : EdgeInsets.symmetric(horizontal: widget.size.width / 2),
//         child: Container(
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: AnimatedOpacity(
//                   duration: const Duration(milliseconds: 200),
//                   opacity:
//                       widget.explinationBoxShowed && !widget.explinationDone
//                           ? 1
//                           : 0,
//                   child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 18, horizontal: 15),
//                       width: widget.size.width,
//                       height: 57,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Theme.of(context).backgroundColor,
//                           border: Border.all(
//                               color: const Color.fromARGB(255, 22, 151, 202))),
//                       child: AnimatedTextKit(
//                         animatedTexts: [
//                           TypewriterAnimatedText(
//                             'first_meaning,second_meaning',
//                             speed: const Duration(milliseconds: 60),
//                             textStyle: const TextStyle(
//                                 color: Colors.white, fontSize: 16),
//                           )
//                         ],
//                         repeatForever: true,
//                       )),
//                 ),
//               ),
//               AnimatedPositioned(
//                 duration: const Duration(milliseconds: 300),
//                 top: widget.explinationContentShowed && !widget.explinationDone
//                     ? 57
//                     : 65,
//                 left: 0,
//                 right: 0,
//                 child: AnimatedOpacity(
//                   duration: const Duration(milliseconds: 300),
//                   opacity:
//                       widget.explinationContentShowed && !widget.explinationDone
//                           ? 1
//                           : 0,
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: Text(
//                       'In order to add more than one meaning for a word make sure to put " , " between each two meanings.',
//                       style: TextStyle(
//                         fontSize: 16,
//                         height: 1.3,
//                         shadows: [Shadow(color: Colors.black, blurRadius: 1)],
//                         color: kPimaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               AnimatedPositioned(
//                   duration: const Duration(milliseconds: 300),
//                   bottom:
//                       widget.explinationContentShowed && !widget.explinationDone
//                           ? 0
//                           : 0,
//                   right: 0,
//                   child: AnimatedOpacity(
//                     duration: const Duration(milliseconds: 300),
//                     opacity: widget.explinationContentShowed &&
//                             !widget.explinationDone
//                         ? 1
//                         : 0,
//                     child: GestureDetector(
//                       onTap: () async {
//                         sharedPreferences =
//                             await SharedPreferences.getInstance();

//                         sharedPreferences.setBool(
//                             'explinationContentShowed', false);
//                         // WordData.setContentShowed(false);
//                         await Future.delayed(const Duration(milliseconds: 350),
//                             () {
//                           sharedPreferences.setBool(
//                               'explinationBoxShowed', false);
//                         });
//                         Future.delayed(const Duration(milliseconds: 300),
//                             () => widget.fn2.requestFocus());
//                         sharedPreferences.setBool('explinationDone', true);
//                         widget.load();
//                         // WordData.setExDone();
//                       },
//                       child: Container(
//                         child: const Center(
//                           child: Text('Got it',
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900)),
//                         ),
//                         width: 120,
//                         height: 100,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.only(
//                             bottomRight: Radius.elliptical(50, 50),
//                             topRight: Radius.elliptical(50, 50),
//                             topLeft: Radius.elliptical(50, 50),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )),
//             ],
//           ),
//           height: 300,
//           // margin: const EdgeInsets.symmetric(horizontal: 30),
//           decoration: const BoxDecoration(
//             color: Colors.blue,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//               bottomLeft: Radius.elliptical(50, 50),
//               bottomRight: Radius.elliptical(50, 50),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
