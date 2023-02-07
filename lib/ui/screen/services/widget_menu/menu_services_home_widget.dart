import 'package:flutter/material.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'controller/menu_services_controller.dart';
import 'menu_services_widget.dart';

class MenuServicesHomeWidget extends StatelessWidget {
  final GlobalKey? allServicesKey;

  const MenuServicesHomeWidget({
    Key? key,
    this.allServicesKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuServicesController>(
      init: MenuServicesController(),
      builder: (controller) {
        return MenuServicesWidget(
          services: controller.menuServicesHome,
          allServicesKey: allServicesKey,
        );
      },
    );
  }
}
