import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';

class SeparatorShapeWidget extends StatelessWidget {
  const SeparatorShapeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: ColorUI.shape,
      thickness: 12,
    );
  }
}
