import 'package:qoin_sdk/controllers/qoin_digitalid/liveness_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class LivenessBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<LivenessController>(LivenessController());
  }
}
