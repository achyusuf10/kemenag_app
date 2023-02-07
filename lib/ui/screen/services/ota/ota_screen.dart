import 'package:flutter/material.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/screen/payment/web_view_page.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class OtaScreen extends StatefulWidget {
  final qoin.OtaType otaType;

  const OtaScreen({key, this.otaType = qoin.OtaType.Tour}) : super(key: key);

  @override
  _OtaScreenState createState() => _OtaScreenState();
}

class _OtaScreenState extends State<OtaScreen> {
  @override
  void initState() {
    super.initState();

    qoin.OtaController.to.openOta(
        onSuccess: (url) {},
        onProfileNotComplete: () {
          if (mounted) {
            DialogUtils.showCompleteProfileDrawer();
          }
        },
        onFailed: (error) {
          DialogUtils.showPopUp(
            type: DialogType.problem,
            buttonFunction: () {
              qoin.Get.back();
              qoin.Get.back();
            },
          );
        },
        otaType: widget.otaType);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.OtaController.to.isLoadingMain.stream,
      child: Scaffold(
        appBar: null,
        body: qoin.GetBuilder<qoin.OtaController>(
          builder: (controller) {
            if (controller.otaUrl != null &&
                widget.otaType == qoin.OtaType.Tour) {
              return WebViewPage(
                title: QoinServicesLocalization.serviceMenuTour.tr,
                url: controller.otaUrl ?? "",
                onBack: () {
                  qoin.Get.back();
                },
              );
            } else if (controller.otaTravelUrl != null &&
                widget.otaType == qoin.OtaType.Travel) {
              return WebViewPage(
                title: QoinServicesLocalization.serviceMenuTravel.tr,
                url: controller.otaTravelUrl ?? "",
                onBack: () {
                  qoin.Get.back();
                },
              );
            } else if (controller.membershipUrl != null &&
                widget.otaType == qoin.OtaType.Membership) {
              return WebViewPage(
                title: QoinServicesLocalization.serviceMenuOtaquMembership.tr,
                url: controller.membershipUrl ?? "",
                onBack: () {
                  qoin.Get.back();
                },
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => controller.openOta(
                    onSuccess: (url) {},
                    onProfileNotComplete: () {},
                    onFailed: (error) {
                      DialogUtils.showPopUp(
                        type: DialogType.problem,
                        buttonFunction: () {
                          qoin.Get.back();
                          qoin.Get.back();
                        },
                      );
                    },
                    otaType: widget.otaType),
                child: ListView.builder(
                    itemCount: 5, itemBuilder: (_, index) => Container()),
              );
            }
          },
        ),
      ),
    );
  }
}
