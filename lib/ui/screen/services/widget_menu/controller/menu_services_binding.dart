import 'package:qoin_sdk/qoin_sdk.dart';

import 'menu_services_controller.dart';

class MenuServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MenuServicesController>(MenuServicesController());
  }
}
