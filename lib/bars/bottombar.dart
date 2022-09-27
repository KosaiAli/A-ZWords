import 'package:azwords/Function/worddata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, worddata, child) => AnimatedSlide(
        curve: Curves.easeOutExpo,
        duration: const Duration(milliseconds: 600),
        offset: Offset(0, worddata.adding || worddata.scrolling ? 5 : 0),
        child: CustomPaint(
          size: Size(size.width, 60),
          painter: size.width < size.height
              ? CPainter(c: Theme.of(context).backgroundColor)
              : CPainter2(c: Theme.of(context).backgroundColor),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: BottomBarButton(),
          ),
        ),
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => wordProvider.setBarButton(1),
              child: Column(
                children: const [
                  ButtonIcon(
                    image: 'assets/Images/home.png',
                    index: 1,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  SelectedbarButton(index: 1),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                wordProvider.setBarButton(2);
              },
              child: Column(
                children: [
                  Container(
                      transform: Matrix4.translationValues(2, 0, 0),
                      child: const ButtonIcon(
                          image: 'assets/Images/test.png', index: 2)),
                  const SizedBox(
                    height: 3,
                  ),
                  const SelectedbarButton(
                    index: 2,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({Key? key, required this.image, required this.index})
      : super(key: key);
  final String image;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, wordProvider, child) => AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: wordProvider.barButtonSelected == index ? 0.9 : 0.8,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 30,
          width: 30,
          child: Image.asset(image, color: Colors.white),
        ),
      ),
    );
  }
}

class SelectedbarButton extends StatelessWidget {
  const SelectedbarButton({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, worfProvider, child) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: worfProvider.barButtonSelected == index ? 15 : 3,
        height: 3,
        decoration: BoxDecoration(
          color: worfProvider.barButtonSelected == index
              ? Colors.blue
              : Colors.grey,
          borderRadius: BorderRadius.circular(35),
        ),
      ),
    );
  }
}

class CPainter extends CustomPainter {
  CPainter({required this.c});
  final Color c;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = c
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(40, 50);

    path.quadraticBezierTo(40, 20, 70, 20);
    path.lineTo(size.width * 0.35, 20);
    path.quadraticBezierTo(size.width * 0.419, 20, size.width * 0.419, 35);
    path.quadraticBezierTo(size.width * 0.425, 65, size.width * 0.50, 67);
    path.quadraticBezierTo(size.width * 0.575, 65, size.width * 0.581, 35);
    path.quadraticBezierTo(size.width * 0.581, 20, size.width * 0.64, 20);

    path.lineTo(size.width - 70, 20);
    path.quadraticBezierTo(size.width - 40, 20, size.width - 40, 50);
    path.quadraticBezierTo(size.width - 40, 80, size.width - 70, 80);
    path.lineTo(size.width, 80);
    path.lineTo(70, 80);
    path.quadraticBezierTo(40, 80, 40, 50);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CPainter2 extends CustomPainter {
  CPainter2({required this.c});
  final Color c;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = c
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(40, 50);

    path.quadraticBezierTo(40, 20, 70, 20);
    path.lineTo(size.width * 0.38, 20);
    path.quadraticBezierTo(size.width * 0.449, 20, size.width * 0.449, 35);
    path.quadraticBezierTo(size.width * 0.455, 65, size.width * 0.50, 67);
    path.quadraticBezierTo(size.width * 0.545, 65, size.width * 0.551, 35);
    path.quadraticBezierTo(size.width * 0.551, 20, size.width * 0.61, 20);

    path.lineTo(size.width - 70, 20);
    path.quadraticBezierTo(size.width - 40, 20, size.width - 40, 50);
    path.quadraticBezierTo(size.width - 40, 80, size.width - 70, 80);
    path.lineTo(size.width, 80);
    path.lineTo(70, 80);
    path.quadraticBezierTo(40, 80, 40, 50);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
