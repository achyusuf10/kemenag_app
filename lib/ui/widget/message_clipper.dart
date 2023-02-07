import 'package:flutter/material.dart';

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var middle = size.width / 2;

    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(middle, size.height);
    // path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
