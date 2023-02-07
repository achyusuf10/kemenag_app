import 'package:inisa_app/logic/controller/register_form_digital_id_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class RegisterFormDigitalIdBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RegisterFormDigitalIdController>(RegisterFormDigitalIdController());
  }
}
