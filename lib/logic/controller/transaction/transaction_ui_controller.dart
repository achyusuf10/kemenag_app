import 'package:qoin_sdk/qoin_sdk.dart';

class TranscactionUIController extends GetxController {
  bool _deleteMode = false;
  RxInt tabIndex = 0.obs;

  set deleteMode(bool value) {
    _deleteMode = value;
    update();
  }

  bool get deleteMode => _deleteMode;

}