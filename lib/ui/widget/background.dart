import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:get/get.dart';

class Background extends StatelessWidget {
  double? height;

  Background({this.height = 230});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: Get.theme.colorScheme.primary,
    );
  }
}
