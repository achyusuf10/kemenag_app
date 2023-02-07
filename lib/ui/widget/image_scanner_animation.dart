import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';

class ImageScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double width;
  final Color colorOne;
  final Color colorTwo;

  ImageScannerAnimation(this.stopped, this.width, {Key? key, Animation<double>? animation})
      : colorOne = ColorUI.secondary,
        colorTwo = Color(0x00FF4242),
        super(key: key, listenable: animation!);

  ImageScannerAnimation.qoin(this.stopped, this.width, {Key? key, Animation<double>? animation})
      : colorOne = Color(0xfff48e2d),
        colorTwo = Color(0x00fac15a),
        super(key: key, listenable: animation!);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final scorePosition = (animation.value * MediaQuery.of(context).size.height) - 100;

    Color color1 = colorOne;
    Color color2 = colorTwo;

    if (animation.status == AnimationStatus.reverse) {
      color1 = colorTwo;
      color2 = colorOne;
    }

    return new Positioned(
        bottom: scorePosition,
        child: new Opacity(
            opacity: (stopped) ? 0.0 : 1.0,
            child: Container(
              height: 80.0,
              width: width,
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.01, 0.9],
                colors: [color1, color2],
              )),
            )));
  }
}
