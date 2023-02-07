import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double radius;
  final double fontSize;
  final double height;
  final double borderWidth;
  final Color? borderColor;
  final bool mini;

  const SecondaryButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.color,
      this.textColor,
      this.radius = 4,
      this.fontSize = 16,
      this.height = 48,
      this.borderWidth = 1.0,
      this.borderColor,
      this.mini = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(text),
      onPressed: onPressed,
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
            width: borderWidth,
            color: borderColor ?? Get.theme.colorScheme.primary,
            style: BorderStyle.solid,
          ),
        ),
        minimumSize: mini ? null : MaterialStateProperty.all<Size>(Size(double.infinity, height.h)),
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.r),
        )),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all<Color>(onPressed == null
            ? Color(0xffb5b5b5)
            : color != null
                ? color!
                : Get.theme.backgroundColor),
        foregroundColor: MaterialStateProperty.all<Color>(onPressed == null
            ? Colors.white
            : textColor != null
                ? textColor!
                : Get.theme.colorScheme.primary),
        textStyle: MaterialStateProperty.all<TextStyle>(TextUI.buttonTextBlack),
      ),
    );
  }
}
