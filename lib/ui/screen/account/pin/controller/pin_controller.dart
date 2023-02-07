import 'package:qoin_sdk/qoin_sdk.dart';

class PinController extends GetxController {
  static PinController get to => Get.find();

  var pin = ''.obs;
  var pinConfirmation = ''.obs;
}
