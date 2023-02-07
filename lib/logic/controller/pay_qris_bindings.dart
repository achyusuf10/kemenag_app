import 'package:qoin_sdk/qoin_sdk.dart';

class PayQrisBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<SlideUpController>(SlideUpController());
    Get.put<QrWalletController>(QrWalletController());
  }
}
