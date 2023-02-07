import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';

class OvalBackground extends StatelessWidget {
  final int turnRotate;
  final double? heightPrimary;
  final double? heightBackground;
  final Widget? childInside;

  const OvalBackground(
      {key, this.turnRotate = 0, this.heightPrimary, this.heightBackground, this.childInside})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = heightBackground ?? 192;
    return RotatedBox(
      quarterTurns: turnRotate,
      child: Stack(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: heightPrimary ?? height + 19.2,
              color: ColorUI.secondary,
            ),
          ),
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: height,
              color: ColorUI.secondary,
              child: childInside,
            ),
          ),
        ],
      ),
    );
  }
}

/// Oval bottom clipper to clip widget in oval shape at the bottom side
class OvalBottomBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - size.width / 4, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
