import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';

class TitleSectionText extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;
  const TitleSectionText({Key? key, required this.title, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding ?? const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
        child: Text(
          title,
          style: TextUI.subtitleBlack,
        ));
  }
}
