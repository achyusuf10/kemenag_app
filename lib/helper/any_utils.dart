import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/constans.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/onboarding/onboarding_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AnyUtils {
  static String phoneNumberConvert(String phoneNumber) {
    String standardNumber;
    standardNumber =
        phoneNumber.replaceAll('-', '').replaceAll(' ', '').replaceAll('+', '');
    if (standardNumber.startsWith('0')) {
      standardNumber = standardNumber.substring(1);
    }
    if (standardNumber.startsWith('62')) {
      standardNumber = standardNumber.substring(2);
    }
    return standardNumber;
  }

  static share({List<String>? imagePaths, String? message}) {
    if (message != null && imagePaths != null) {
      Share.shareFiles(imagePaths, text: message);
      return;
    } else if (message != null) {
      Share.share(message);
      return;
    } else if (imagePaths != null) {
      Share.shareFiles(imagePaths);
      return;
    }
  }

  static String timeAgo(DateTime d) {
    // Duration diff = DateTime.now().difference(d);
    tz.initializeTimeZones();
    var now = tz.TZDateTime.now(tz.getLocation(Constans.serverTimeLocation));
    Duration diff = now.difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? QoinTransactionLocalization.trxYear.tr : QoinTransactionLocalization.trxYears.tr} ${QoinTransactionLocalization.trxAgo.tr}";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? QoinTransactionLocalization.trxMonth.tr : QoinTransactionLocalization.trxMonths.tr} ${QoinTransactionLocalization.trxAgo.tr}";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? QoinTransactionLocalization.trxWeek.tr : QoinTransactionLocalization.trxWeeks.tr} ${QoinTransactionLocalization.trxAgo.tr}";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? QoinTransactionLocalization.trxDay.tr : QoinTransactionLocalization.trxDays.tr} ${QoinTransactionLocalization.trxAgo.tr}";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? QoinTransactionLocalization.trxHour.tr : QoinTransactionLocalization.trxHours.tr} ${QoinTransactionLocalization.trxAgo.tr}";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? QoinTransactionLocalization.trxMinute.tr : QoinTransactionLocalization.trxMinutes.tr} ${QoinTransactionLocalization.trxAgo.tr}";
    return QoinTransactionLocalization.trxJustNow.tr;
  }

  static convertToLocal(String d) {
    try {
      var tempString = d + Constans.serverTimeStringAddition;
      return DateFormat("dd-MM-yyyy - HH:mm")
          .format(DateTime.parse(tempString).toLocal());
    } catch (e) {
      return d;
    }
  }
}

String formatHHMMSS(int seconds) {
  int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  if (hours == 0) {
    return "$minutesStr:$secondsStr";
  }

  return "$hoursStr:$minutesStr:$secondsStr";
}

class IntentTo {
  static customerServices() async {
    var whatsapp = "+628119349088";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp /* + "&text=hello"*/;
    var whatappURL_ios =
        "https://wa.me/$whatsapp"; //?text=${Uri.parse("hello")}
    if (Platform.isIOS) {
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        StoreRedirect.redirect(
            androidAppId: "com.whatsapp", iOSAppId: "310633997");
      }
    } else {
      if (await canLaunch(whatsappURl_android)) {
        //await launch(whatsappURl_android);
        await launch(
            "whatsapp://send/?phone=%2B628111529088text=Halo%20saya%20ingin%20bertanya%20lebih%20lanjut%20mengenai%20QOIN&app_absent=0");
      } else {
        StoreRedirect.redirect(
            androidAppId: "com.whatsapp", iOSAppId: "310633997");
      }
    }
  }

  static checkUpdate() {
    Future.delayed(Duration(seconds: 2), () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionCode = packageInfo.buildNumber;
      AccountsController.instance.checkVersion(int.parse(versionCode),
          upToDate: () {}, notUpdateYet: () {
        DialogUtils.showMainPopup(
          radius: 10,
          barrierDismissible: false,
          image: Assets.warning,
          title: Localization.updateNotice.tr,
          description: Localization.updateAppDesc.tr,
          mainButtonText: Localization.update.tr,
          mainButtonFunction: () async {
            var url;
            if (Platform.isAndroid) {
              url = 'https://play.google.com/store/apps/details?id=id.inisa';
            } else {
              url = 'https://apps.apple.com/id/app/inisa/id1594131499';
            }
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        );
      }, onFailed: () {}, isProtoType: false);
    });
  }

  static sessionExpired() {
    Get.offAll(() => PinScreen(
          pinType: PinTypeEnum.login,
        ));
    Get.rawSnackbar(
        message: 'Session telah habis, silahkan login kembali', backgroundColor: ColorUI.secondary);
  }
}

class InitialName {
  // @string name
  // @int count (optional) to limit the number of letters that appear
  static String parseName(String name, {int? count}) {
    // separate each word
    var nameHelper = name.replaceFirst(" ", "");
    var parts = nameHelper.split(' ');
    var initial = '';

    // check length
    if (parts.length > 1) {
      // check max limit
      if (count != null) {
        for (var i = 0; i < count; i++) {
          // combine the first letters of each word
          try {
            initial += parts[i][0];
          } catch (e) {}
        }
      } else {
        // this default, if word > 1
        try {
          initial = parts[0][0] + parts[1][0];
        } catch (e) {}
      }
    } else {
      // this default, if word <=1
      try {
        initial = parts[0][0];
      } catch (e) {}
    }
    return initial;
  }
}

class WidgetUtils {
  static Future capture(GlobalKey key) async {
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$directory/INISA_${DateTime.now().millisecondsSinceEpoch}.png');
    await imgFile.writeAsBytes(pngBytes);
    debugPrint(imgFile.path);
    return imgFile;
  }
}
