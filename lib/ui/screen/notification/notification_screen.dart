import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'notification_activity_tab.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    tabController!.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ModalProgress(
      loadingStatus: qoin.QoinWalletController.to.isMainLoading.stream,
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: QoinTransactionLocalization.titleNotif.tr,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              color: qoin.Get.theme.backgroundColor,
              child: Column(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(40),
                    margin: EdgeInsets.fromLTRB(
                      ScreenUtil().setHeight(16),
                      0,
                      ScreenUtil().setHeight(16),
                      ScreenUtil().setHeight(16),
                    ),
                    child: TabBar(
                      controller: tabController,
                      unselectedLabelColor: Colors.grey,
                      labelColor: ColorUI.text_1,
                      indicatorColor: ColorUI.text_1,
                      tabs: [
                        Tab(
                          child: Text(
                            QoinTransactionLocalization.activity.tr,
                            style: TextUI.subtitleBlack,
                            textScaleFactor: 1.0,
                          ),
                        ),
                        Tab(
                          child: Text(
                            QoinTransactionLocalization.information.tr,
                            style: TextUI.subtitleBlack,
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FilterWidget()
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: qoin.Get.theme.backgroundColor,
                child: TabBarView(
                  controller: tabController,
                  dragStartBehavior: DragStartBehavior.start,
                  children: [
                    NotificationActivityTab(
                      tabIndex: 0,
                    ),
                    NotificationActivityTab(
                      tabIndex: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
