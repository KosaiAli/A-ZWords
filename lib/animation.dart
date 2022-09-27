import 'package:flutter/cupertino.dart';

class FadeNavigator extends PageRouteBuilder {
  Widget page;
  FadeNavigator({required this.page})
      : super(
          pageBuilder: (context, animation, animationtwo) => page,
          transitionsBuilder: (context, animation, animationtwo, child) {
            var begin = 0.0;
            var end = 1.0;
            var tween = Tween(begin: begin, end: end);

            var offsetanimation = CurvedAnimation(
                parent: animation,
                curve: Curves.ease,
                reverseCurve: Curves.easeOut);

            return FadeTransition(
              opacity: tween.animate(offsetanimation),
              child: child,
            );
          },
        );
}

class SliderNavigator extends PageRouteBuilder {
  Widget page;
  SliderNavigator({required this.page})
      : super(
          pageBuilder: (context, animation, animationtwo) => page,
          transitionsBuilder: (context, animation, animationtwo, child) {
            var begin = const Offset(0, 1);
            var end = const Offset(0, 0);
            var tween = Tween(begin: begin, end: end);

            var offsetanimation = CurvedAnimation(
                parent: animation,
                curve: Curves.ease,
                reverseCurve: Curves.easeOut);

            return SlideTransition(
              position: tween.animate(offsetanimation),
              child: child,
            );
          },
        );
}
