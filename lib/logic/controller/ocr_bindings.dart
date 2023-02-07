import 'package:qoin_sdk/controllers/qoin_digitalid/ocr_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class OcrBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<OcrController>(OcrController());
    Get.put<QoinCameraController>(QoinCameraController());
  }
}
