import 'package:qoin_sdk/qoin_sdk.dart';

class QoinWalletTfBankBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<QoinWalletTransferBankController>(QoinWalletTransferBankController());
  }
}
