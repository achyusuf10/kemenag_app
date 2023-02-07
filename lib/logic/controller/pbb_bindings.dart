import 'package:qoin_sdk/qoin_sdk.dart';
// import 'package:venturo_mobile/venturo_pbb/logic/controllers/venturo_pbb_controller.dart';

class PbbBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<PbbController>(PbbController());
    // Get.put(VenturoPbbController());
  }
}
