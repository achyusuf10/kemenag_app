import 'package:qoin_sdk/qoin_sdk.dart';

class PaymentBinding extends Bindings {
  final String? typeServicePpob;

  PaymentBinding({
    this.typeServicePpob,
  });

  @override
  void dependencies() {
    Get.put<PaymentController>(PaymentController());
  }
}
