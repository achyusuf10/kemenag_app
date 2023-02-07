import 'package:qoin_sdk/controllers/qoin_notification/notification_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class NotificationBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationController>(NotificationController());
  }
}
