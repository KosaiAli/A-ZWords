import 'dart:io';

import 'package:azwords/Function/worddata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    var imageLoaded =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageLoaded != null) {
      File file = File(imageLoaded.path);
      _storage
          .ref('imagePics/${_auth.currentUser?.uid}.jpg')
          .putFile(file)
          .then((snapshot) {
        snapshot.ref.getDownloadURL().then((value) {
          _firestore
              .collection('users')
              .doc(_auth.currentUser?.uid)
              .set({'profilePic': value});
        });
      });
    }
  }

  int level = 2;

  Color get getcolor {
    if (level == 1) {
      return Colors.red;
    } else if (level > 1 && level < 5) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  List<Widget> levelWidget(int l) {
    List<Widget> list = [];

    for (int i = 1; i <= 5; i++) {
      list.add(Container(
        width: 7,
        height: 7.0 * i,
        decoration: BoxDecoration(
          color: i <= l ? getcolor : null,
          border: const Border.symmetric(
            vertical: BorderSide(color: Colors.white, width: 0.5),
            horizontal: BorderSide(color: Colors.white, width: 1),
          ),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(builder: (context, wordProvider, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: getImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage:
                              const AssetImage('assets/Images/user.png'),
                          foregroundImage: wordProvider.user.profilePic != null
                              ? NetworkImage(wordProvider.user.profilePic!)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          'Kosai Ali',
                          style: TextStyle(
                              fontSize: 28,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: levelWidget(level),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          // color: Colors.blue,
                          child: CustomPaint(
                              painter:
                                  WeeklyReport(list: wordProvider.user.res)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          // color: Colors.blue,
                          child: CustomPaint(
                              painter:
                                  WeeklyReport(list: wordProvider.user.res2)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      );
    });
  }
}

class WeeklyReport extends CustomPainter {
  WeeklyReport({required this.list});
  QuerySnapshot<Map<String, dynamic>> list;
  List<double> percent = [];
  @override
  void paint(Canvas canvas, Size size) async {
    _calculatePercents();

    Path path = Path();
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(0, 200), Offset(size.width, 200), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
    try {
      path.moveTo(size.width * (1) / 7, 200 - (200 * percent[0] / 100));
    } catch (e) {
      return;
    }
    for (int i = 0; i < 7; i++) {
      if (i < percent.length) {
        _drawLine(path, i, size, percent, canvas, paint);
      }
    }
    for (int i = 0; i < 7; i++) {
      if (i < percent.length) {
        _drawCircle(canvas, i, size, percent, paint);
      }
    }
  }

  void _calculatePercents() {
    for (int i = 0; i < list.docs.length; i++) {
      var result = list.docs[i].data()['result'] as Map;
      if (result.isNotEmpty) {
        int n = 0;
        result.values.toList().forEach((element) {
          if (element == true) {
            n++;
          }
        });
        percent.add(n * 100 / result.length);
      } else {
        percent.add(0);
      }
    }
  }

  Offset _calculatePosition(int i, Size size, List<double> percent) {
    return Offset(size.width * (i) / 7, 200 - (200 * percent[i] / 100)) +
        Offset(size.width / 7, 0);
  }

  void _drawLine(Path path, int i, Size size, List<double> percent,
      Canvas canvas, Paint paint) {
    path.lineTo(
      _calculatePosition(i, size, percent).dx,
      _calculatePosition(i, size, percent).dy,
    );
    canvas.drawPath(path, paint);
  }

  void _drawCircle(
      Canvas canvas, int i, Size size, List<double> percent, Paint paint) {
    canvas.drawCircle(
        _calculatePosition(i, size, percent), 6, paint..strokeWidth = 3);
    Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    canvas.drawCircle(_calculatePosition(i, size, percent), 5, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
