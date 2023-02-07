import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/ui/screen/account/profile/profile_edit_screen.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class Functions {
  static String? convertPeriode({int? serviceId, String? value}) {
    if (value != null && value.isNotEmpty) {
      if (serviceId == Services.servicesId.bpjsKesehatan) {
        return QoinServicesLocalization.serviceTextMonth.trParams({"month": value});
      }
      if (serviceId == Services.servicesId.pajakPBB) {
        return value;
      }
      String year = value.substring(0, 4);
      String month = value.substring(4, 6);
      return "${_sMonth(month)} $year";
    } else {
      return value ?? "";
    }
  }

  static String _sMonth(String value) {
    switch (value) {
      case "01":
        return Localization.jan.tr;
      case "02":
        return Localization.feb.tr;
      case "03":
        return Localization.march.tr;
      case "04":
        return Localization.april.tr;
      case "05":
        return Localization.may.tr;
      case "06":
        return Localization.june.tr;
      case "07":
        return Localization.july.tr;
      case "08":
        return Localization.aug.tr;
      case "09":
        return Localization.sep.tr;
      case "10":
        return Localization.oct.tr;
      case "11":
        return Localization.nov.tr;
      case "12":
        return Localization.des.tr;
      default:
        return value;
    }
  }

  static void checkEmailConfirmedBeforeInquiry({required Function() onInquiry}) {
    if (HiveData.userData!.emailConfirmed == true) {
      onInquiry();
    } else {
      DialogUtils.showMainPopup(
        barrierDismissible: true,
        image: 'assets/voucher_bansos/images/no_succes_request.png',
        package: 'venturo_mobile',
        title: 'Profil Tidak Lengkap',
        description: 'Anda perlu melakukan verifikasi email',
        mainButtonText: 'Lengkapi Profil',
        mainButtonFunction: () async {
          Get.back();
          Get.to(() => ProfileEditScreen());
        },
        mainPopupButtonDirection: MainPopupButtonDirection.Horizontal,
      );
    }
  }
}
