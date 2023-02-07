import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:qoin_sdk/helpers/services/connectivity_status.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class DigitalIdHelper {
  static getQRData(data) {
    // if (ConnectivityService.connectionStatus == ConnectivityStatus.Offline) {
    //   DialogUtils.showPopUp(type: DialogType.noInternet);
    //   return;
    // }
    DigitalIdController.instance.getQrImage(data: data!).then((value) {
      if (DigitalIdController.instance.qrError != null) {
        if (DigitalIdController.instance.qrError == 'relogin') {
          IntentTo.sessionExpired();
        }
      }
    });
  }
}
