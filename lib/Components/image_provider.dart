import 'dart:convert';

import 'package:azwords/Function/worddata.dart';
import 'package:azwords/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class ImagesProv extends StatefulWidget {
  const ImagesProv({
    Key? key,
  }) : super(key: key);

  @override
  State<ImagesProv> createState() => _ImagesProvState();
}

class _ImagesProvState extends State<ImagesProv> {
  String? word;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    word = Provider.of<WordData>(context, listen: false).onlineSearchedWord;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 4,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(25)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Text(
                'Choose an image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        if (word != null)
          FutureBuilder<http.Response>(
            future: http.get(
              Uri.parse(
                  'https://api.unsplash.com/search/photos?query=$word&client_id=RmP_kKNDRu_NS9ztHm6Ea00ZnpLlpUQV-3-rGNFNG-I'),
            ),
            builder: (context, snapshot) {
              if (snapshot.data?.statusCode == 200) {
                var jsoncode = jsonDecode(snapshot.data!.body);
                List a = jsoncode['results'];
                if (a.isNotEmpty) {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: a.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (!Provider.of<WordData>(context, listen: false)
                                .adding) {
                              Provider.of<WordData>(context, listen: false)
                                      .deitingOrAddingWord
                                      .photoURL =
                                  jsoncode['results'][index]['urls']['small'];
                            }
                            await _fireStore
                                .collection('users')
                                .doc(_auth.currentUser?.uid)
                                .collection('words')
                                .doc(Provider.of<WordData>(context,
                                        listen: false)
                                    .onlineSearchedWord)
                                .set({
                              'meanings':
                                  Provider.of<WordData>(context, listen: false)
                                      .meanings,
                              'fav': false,
                              'photoUrl': jsoncode['results'][index]['urls']
                                  ['small']
                            }).then((value) {
                              Fluttertoast.showToast(
                                  gravity: ToastGravity.SNACKBAR,
                                  msg: 'Successfully added with an image',
                                  fontSize: 16,
                                  textColor: kPimaryColor,
                                  backgroundColor: Colors.white);

                              Provider.of<WordData>(context, listen: false)
                                  .updateWords();
                              Provider.of<WordData>(context, listen: false)
                                  .panelController
                                  .close();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 3),
                                      blurRadius: 5)
                                ]),
                            margin: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                jsoncode['results'][index]['urls']['small'],
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress?.cumulativeBytesLoaded ==
                                      loadingProgress?.expectedTotalBytes) {
                                    return child;
                                  }
                                  return Shimmer.fromColors(
                                    highlightColor: Colors.grey[100]!,
                                    baseColor: Colors.grey[300]!,
                                    child: Container(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('No result found'),
                );
              }
              return const Center(
                  child: RefreshProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2.5,
              ));
            },
          ),
        GestureDetector(
          onTap: () async {
            if (!Provider.of<WordData>(context, listen: false).adding) {
              Provider.of<WordData>(context, listen: false)
                  .deitingOrAddingWord
                  .photoURL = null;
            }
            await _fireStore
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .collection('words')
                .doc(Provider.of<WordData>(context, listen: false)
                    .onlineSearchedWord)
                .set({
              'meanings':
                  Provider.of<WordData>(context, listen: false).meanings,
              'fav': false,
              'photoUrl': null
            }).then((value) {
              Provider.of<WordData>(context, listen: false).updateWords();
              Fluttertoast.showToast(
                  gravity: ToastGravity.SNACKBAR,
                  msg: 'Successfully added without an image',
                  fontSize: 16,
                  textColor: kPimaryColor,
                  backgroundColor: Colors.white);
              Provider.of<WordData>(context, listen: false)
                  .panelController
                  .close();
            });
          },
          child: Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, -5),
                    blurRadius: 10)
              ],
              color: Colors.blue,
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        )
      ],
    );
  }
}
