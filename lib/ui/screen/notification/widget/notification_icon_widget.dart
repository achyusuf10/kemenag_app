import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/ui/screen/notification/helper/notification_bindings.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import '../notification_screen.dart';

class NotificationIconWidget extends StatefulWidget {
  const NotificationIconWidget({key}) : super(key: key);

  @override
  _NotificationIconWidgetState createState() => _NotificationIconWidgetState();
}

class _NotificationIconWidgetState extends State<NotificationIconWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
        onTap: () async {
          Get.to(() => NotificationScreen(), binding: NotificationBindings());
        },
        child: Icon(
          Icons.notifications,
          color: Get.theme.backgroundColor,
        )
        // Obx(
        //   () => Badge(
        //     animationType: BadgeAnimationType.scale,
        //     showBadge: true,
        //     badgeContent: Text(
        //       'Isi',
        //       style: TextUI.subtitleWhite,
        //       textScaleFactor: 1.0,
        //     ),
        //     badgeColor: Colors.red,
        //     child: Icon(
        //       Icons.notifications,
        //       color: Get.theme.backgroundColor,
        //     ),
        //   ),
        // ),
        );
  }
}
