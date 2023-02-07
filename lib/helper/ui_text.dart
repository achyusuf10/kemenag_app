import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextUI {
  static final headerWhite = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 36.sp,
    color: ColorUI.white,
  );

  static final headerBlack = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 36.sp,
    color: ColorUI.text_1,
  );

  static final header2White = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 25.sp,
    color: ColorUI.white,
  );

  static final header2Grey = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 25.sp,
    color: ColorUI.text_4,
  );

  static final header2Black = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 25.sp,
    color: ColorUI.text_1,
  );

  static final titleYellow = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 21.sp,
    color: ColorUI.yellow,
  );

  static final titleWhite = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 21.sp,
    color: ColorUI.white,
  );

  static final titleGrey = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 21.sp,
    color: ColorUI.text_4,
  );

  static final titleBlack = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 21.sp,
    color: ColorUI.new_layer_style,
  );

  static final title2Yellow = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 18.sp,
    color: ColorUI.yellow,
  );

  static final title2White = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 18.sp,
    color: ColorUI.white,
  );

  static final title2Grey = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 18.sp,
    color: ColorUI.text_4,
  );

  static final title2Black = GoogleFonts.manrope(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: ColorUI.text_1,
  );

  static final subtitleWhite = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    color: ColorUI.shape,
  );

  static final subtitleRed = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    color: ColorUI.secondary,
  );

  static final subtitleBlack = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    color: ColorUI.text_1,
  );

  static final buttonTextYellow = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    color: ColorUI.yellow,
  );

  static final buttonTextRed = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    color: ColorUI.secondary,
  );

  static final buttonTextWhite = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    color: ColorUI.white,
  );

  static final buttonTextUnderline = GoogleFonts.manrope(
      fontWeight: FontWeight.bold,
      fontSize: 16.sp,
      color: ColorUI.yellow,
      decoration: TextDecoration.underline);

  static final buttonTextGrey = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    color: ColorUI.text_4,
  );

  static final buttonTextBlack = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    color: ColorUI.text_1,
  );

  static final bodyTextWhite = Get.theme.textTheme.bodyText1!.copyWith(
    fontSize: 16.sp,
    color: ColorUI.white,
  );

  static final bodyTextYellow = Get.theme.textTheme.bodyText1!.copyWith(
    fontSize: 16.sp,
    color: ColorUI.yellow,
  );

  static final bodyTextWhite2 = Get.theme.textTheme.bodyText1!.copyWith(
    fontSize: 16.sp,
    color: const Color(0xffd1d1d1),
  );

  static final bodyTextGrey = Get.theme.textTheme.bodyText1!.copyWith(
    fontSize: 16.sp,
    color: ColorUI.text_4,
  );

  static final bodyTextDisabled = Get.theme.textTheme.bodyText1!.copyWith(
    fontSize: 16.sp,
    color: ColorUI.disabled,
  );

  static final bodyTextBlack = Get.theme.textTheme.bodyText1!.copyWith(
    fontSize: 16.sp,
    color: ColorUI.text_1,
  );

  static final bodyTextBlack2 = Get.theme.textTheme.bodyText1!.copyWith(
    fontSize: 16.sp,
    color: ColorUI.text_2,
  );

  static final bodyTextBlack3 = Get.theme.textTheme.bodyText1!.copyWith(
    fontSize: 16.sp,
    color: ColorUI.text_3,
  );

  static final placeHolderBlack = Get.theme.textTheme.headline5!.copyWith(
    fontSize: 16.sp,
    color: ColorUI.text_4,
    fontWeight: FontWeight.w400,
  );

  static final bodyText2Yellow = Get.theme.textTheme.bodyText2!.copyWith(
    fontSize: 14.sp,
    color: ColorUI.yellow,
  );

  static final bodyText2White = Get.theme.textTheme.bodyText2!.copyWith(
    fontSize: 14.sp,
    color: ColorUI.white,
  );

  static final bodyText2Grey = Get.theme.textTheme.bodyText2!.copyWith(
    fontSize: 14.sp,
    color: ColorUI.text_4,
  );

  static final bodyText2Grey2 = Get.theme.textTheme.bodyText2!.copyWith(
    fontSize: 14.sp,
    color: ColorUI.text_3,
  );

  static final bodyText2Black = Get.theme.textTheme.bodyText2!.copyWith(
    fontSize: 14.sp,
    color: ColorUI.text_2,
  );

  static final labelWhite = Get.theme.textTheme.headline6!.copyWith(
    fontSize: 14.sp,
    color: ColorUI.white,
    fontWeight: FontWeight.w400,
  );

  static final stepperActive = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.text_1,
    fontWeight: FontWeight.w500,
  );

  static final stepperDisable = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.text_4,
    fontWeight: FontWeight.w400,
  );

  static final labelWhite2 = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.white,
    fontWeight: FontWeight.w400,
  );

  static final labelRed = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.error,
    fontWeight: FontWeight.w400,
  );

  static final labelYellow = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.yellow,
    fontWeight: FontWeight.w400,
  );

  static final labelMenungguPembayaran = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.orange,
    fontWeight: FontWeight.w400,
  );

  static final labelGrey = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.text_3,
    fontWeight: FontWeight.w400,
  );

  static final labelGrey2 = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.text_4,
    fontWeight: FontWeight.w400,
  );

  static final labelBerhasil = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.yellow,
    fontWeight: FontWeight.w400,
  );

  static final labelDibatalkan = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.red,
    fontWeight: FontWeight.w400,
  );

  static final labelBlack = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.text_1,
    fontWeight: FontWeight.w400,
  );

  static final labelBerhasilGreen = Get.theme.textTheme.caption!.copyWith(
    fontSize: 13.sp,
    color: ColorUI.succes,
    fontWeight: FontWeight.w400,
  );
}
