import 'package:flutter/services.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/button_back.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final double elevation;
  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBack;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final Color? backgroundColor;
  final Color? textColor;

  AppBarWidget(
      {this.elevation = 0,
      required this.title,
      this.actions,
      this.bottom,
      this.onBack,
      this.systemUiOverlayStyle,
      this.backgroundColor,
      this.textColor});

  AppBarWidget.light({
    this.elevation = 4.0,
    required this.title,
    this.actions,
    this.bottom,
    this.onBack,
  })  : backgroundColor = Get.theme.backgroundColor,
        textColor = ColorUI.text_1,
        systemUiOverlayStyle = SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark);

  AppBarWidget.red({
    required this.title,
    this.actions,
    this.bottom,
    this.onBack,
  })  : backgroundColor = Get.theme.colorScheme.secondary,
        textColor = Colors.white,
        systemUiOverlayStyle = SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light),
        elevation = 0;

  AppBarWidget.qoin({
    required this.title,
    this.actions,
    this.bottom,
    this.onBack,
  })  : backgroundColor = ColorUI.qoinPrimary,
        textColor = ColorUI.qoinSecondary,
        systemUiOverlayStyle = SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light),
        elevation = 0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: backgroundColor,
      centerTitle: true,
      systemOverlayStyle: systemUiOverlayStyle ??
          SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light),
      title: Text(
        title,
        style: TextUI.subtitleWhite.copyWith(color: textColor),
      ),
      leading: BackButtonWidget(
        color: textColor,
        onPressed: onBack,
        forcePop: onBack != null ? true : false,
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => bottom != null
      ? Size.fromHeight(kToolbarHeight + bottom!.preferredSize.height)
      : Size.fromHeight(kToolbarHeight);
}
