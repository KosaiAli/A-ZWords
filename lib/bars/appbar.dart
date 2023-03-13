import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/profile_screen.dart';
import 'package:azwords/Components/length_info.dart';
import 'package:azwords/Components/online_adding_section.dart';
import 'package:azwords/Components/search_button.dart';
import 'package:azwords/animation.dart';
import 'package:azwords/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AppBar extends StatefulWidget {
  const AppBar({Key? key}) : super(key: key);

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> with SingleTickerProviderStateMixin {
  //used in the functionality of back button
  DateTime timeBackpressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProider, child) => WillPopScope(
        onWillPop: () async {
          if (wordProider.adding) {
            wordProider.setAddingValue(false);
            setState(() {});
            return false;
          }
          final difference = DateTime.now().difference(timeBackpressed);
          final isExitWarning =
              difference >= const Duration(milliseconds: 2000);

          timeBackpressed = DateTime.now();

          if (isExitWarning) {
            Fluttertoast.showToast(
                gravity: ToastGravity.SNACKBAR,
                msg: 'Press back again to exit',
                fontSize: 16,
                textColor: kPimaryColor,
                backgroundColor: Colors.white);
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: AnimatedContainer(
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 600),
          height: wordProider.adding
              ? MediaQuery.of(context).size.height * 0.90
              : MediaQuery.of(context).size.height * 0.27,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.elliptical(60, 60),
              bottomLeft: Radius.elliptical(60, 60),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('A-Z Words', style: kTitle1Style),
                        LengthInfo(),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          SliderNavigator(page: const ProfileScreen()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            const AssetImage('assets/Images/user.png'),
                        foregroundImage: wordProider.user.profilePic != null
                            ? NetworkImage(wordProider.user.profilePic!)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: IgnorePointer(
                              ignoring: !wordProider.adding,
                              child: const OnlineAddingSection(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: SearchBar(
                            size: MediaQuery.of(context).size,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
