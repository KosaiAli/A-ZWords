import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/search_screen.dart';
import 'package:azwords/animation.dart';
import 'package:azwords/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.size}) : super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => AnimatedScale(
        duration: const Duration(milliseconds: 50),
        scale: wordProvider.adding ? 0 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Container(
              height: 50,
              width: size.width - 75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(35),
                ),
              ),
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    SliderNavigator(
                      page: const SearchScreen(),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Search',
                        style: TextStyle(
                            color: kPimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.search,
                        color: kPimaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
