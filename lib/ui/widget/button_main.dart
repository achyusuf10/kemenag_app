import 'package:inisa_app/helper/ui_color.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double radius;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final bool mini;

  const MainButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.color,
      this.textColor,
      this.radius = 4,
      this.height = 48,
      this.padding,
      this.width,
      this.mini = false})
      : super(key: key);

  const MainButton.qoin({
    Key? key,
    required this.text,
    this.onPressed,
    this.padding,
    this.width,
    this.mini = false,
    this.height = 48,
  })  : textColor = ColorUI.qoinSecondary,
        color = ColorUI.qoinPrimary,
        radius = 4,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text),
      onPressed: onPressed,
      style: ButtonStyle(
        // minimumSize: MaterialStateProperty.all<Size>(
        //     Size(width ?? double.infinity, height.h)),
        minimumSize:
            mini ? null : MaterialStateProperty.all<Size>(Size(width ?? double.infinity, height.h)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding ?? EdgeInsets.zero),
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        )),
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all<Color>(onPressed == null
            ? Color(0xffb5b5b5)
            : color != null
                ? color!
                : ColorUI.secondary),
        foregroundColor: MaterialStateProperty.all<Color>(onPressed == null
            ? Colors.white
            : textColor != null
                ? textColor!
                : Colors.white),
        textStyle: MaterialStateProperty.all<TextStyle>(TextUI.buttonTextYellow),
      ),
    );
  }
}
