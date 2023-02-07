import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';

class ButtonImage extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? height;
  final Color? textColor;

  ButtonImage(
      {required this.icon,
      required this.text,
      this.onPressed,
      this.backgroundColor,
      this.borderColor,
      this.borderWidth,
      this.height,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, height ?? 48.0)),
            side: MaterialStateProperty.all<BorderSide>(BorderSide(
              color: borderColor ?? backgroundColor ?? ColorUI.secondary,
              width: borderWidth ?? 1.0,
            )),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            )),
            backgroundColor:
                MaterialStateProperty.all<Color>(backgroundColor ?? ColorUI.secondary)),
        label: Text(text,
            style: textColor == null
                ? TextUI.buttonTextWhite
                : TextUI.buttonTextYellow.copyWith(color: textColor)));
  }
}
