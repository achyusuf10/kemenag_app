import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:shimmer/shimmer.dart';
import 'package:inisa_app/config/inter_module.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/screen/account/profile/profile_edit_screen.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/home/tooltips.dart';
import 'package:inisa_app/ui/screen/news/news_list_screen.dart';
import 'package:inisa_app/ui/screen/notification/widget/notification_icon_widget.dart';
import 'package:inisa_app/ui/screen/services/widget_menu/menu_services_home_widget.dart';
import 'package:inisa_app/ui/widget/background.dart';
import 'package:inisa_app/ui/widget/digital_id/digital_id_home_widget.dart';
import 'package:inisa_app/ui/widget/news_widget.dart';
import 'package:inisa_app/z_qoin/widget/wallet_home_widget.dart';

class HomeTab extends StatefulWidget {
  final GlobalKey qoinCashKey;
  final GlobalKey qoinPoinKey;
  final GlobalKey allServicesKey;
  final GlobalKey addCardTutorialKey;

  HomeTab({
    Key? key,
    required this.qoinCashKey,
    required this.qoinPoinKey,
    required this.allServicesKey,
    required this.addCardTutorialKey,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with WidgetsBindingObserver {
  RefreshController? _refreshController;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();

    _refreshController = RefreshController(initialRefresh: false);
    _scrollController = ScrollController();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    _refreshController?.dispose();
    _scrollController?.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController!,
      scrollController: _scrollController!,
      onRefresh: () async {
        // try {
        //   await qoin.OtaController.to.getListVoucher(
        //       onSuccess: () {
        //         DigitalArchiveUIController.to.joinAllCard();
        //       },
        //       onProfileNotComplete: () {},
        //       onFailed: (error) {});
        // } catch (e) {}
        try {
          await qoin.VoucherTopupController.instance
              .fetchVoucherTopupPurchasedList();
        } catch (e) {}
        try {
          qoin.DigitalIdController.instance.checkDigitalId().then((value) {
            DigitalArchiveUIController.to.joinAllCard();
          });
        } catch (e) {}

        try {
          qoin.OtaController.to.getListTicketManifest(
              onSuccess: () {
                DigitalArchiveUIController.to.joinAllCard();
              },
              onProfileNotComplete: () {},
              onFailed: (error) {});
        } catch (e) {}
        try {
          await qoin.QoinWalletController.to.getAssets();
        } catch (e) {}
        try {
          qoin.AccountsController.instance
              .getProfile(onSuccess: () {}, onError: (error) {});
        } catch (e) {}

        qoin.QoinRemoteConfigController.instance.fetchAndActivate();
        _refreshController!.refreshCompleted();
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Background(height: Platform.isIOS ? 230.h : 230.h),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    qoin.GetBuilder<qoin.AccountsController>(
                        builder: (controller) {
                      return Padding(
                        padding: controller.isHavePicture()
                            ? EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 12.w)
                            : EdgeInsets.fromLTRB(16.w, 9.w, 16.w, 9.w),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => qoin.Get.to(ProfileEditScreen()),
                              child: Image.asset(
                                Assets.inisa,
                                height: 54.w,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            InkWell(
                              onTap: () {},
                              child: SizedBox(
                                width: qoin.Get.width * 0.6,
                                child: Text(
                                  "${Localization.homeHi.tr}, ${(controller.fullName())}",
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextUI.subtitleWhite,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Spacer(),
                            NotificationIconWidget()
                          ],
                        ),
                      );
                    }),
                    DigitalIdHomeWidget(
                      isUsingIndicator: true,
                      isUsingSeeAllButton: true,
                      space: 12,
                      addCardTutorialKey: widget.addCardTutorialKey,
                      bottomInsets: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    // Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 16.w),
                    //     child: WalletHomeWidget(
                    //       qoinCashKey: widget.qoinCashKey,
                    //       qoinPoinKey: widget.qoinPoinKey,
                    //     )),
                    SizedBox(
                      height: 20.h,
                    ),
                    MenuServicesHomeWidget(
                      allServicesKey: widget.allServicesKey,
                    ),

                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Localization.homeLatestNews.tr,
                                style: TextUI.subtitleBlack,
                              ),
                              InkWell(
                                onTap: () {
                                  qoin.Get.to(() => NewsListScreen());
                                },
                                child: Text(
                                  Localization.homeSeeAllNews.tr,
                                  style: TextUI.labelRed,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            Localization.homeLatestNewsDesc.tr,
                            style: TextUI.bodyTextBlack,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: qoin.GetBuilder<qoin.RssFeedInisaController>(
                        init: qoin.RssFeedInisaController(),
                        builder: (controller) {
                          return ListView.builder(
                              itemCount: controller.rssItems.isEmpty ? 0 : 10,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return NewsWidget(
                                    rssItem: controller.rssItems[index]);
                              });
                        },
                      ),
                    ),
                    SizedBox(
                      height: kBottomNavigationBarHeight * 1.5,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!qoin.HiveData.userData!.emailConfirmed! &&
          !InterModule.onReqGetProfileAfterUpdateEmail &&
          InterModule.isEmailEditSuccess) {
        InterModule.onReqGetProfileAfterUpdateEmail = true;
        qoin.AccountsController.instance.getProfile(onSuccess: () {
          InterModule.onReqGetProfileAfterUpdateEmail = false;
          if (qoin.HiveData.userData!.emailConfirmed!) {
            InterModule.isEmailEditSuccess = false;
          }
        }, onError: (error) {
          InterModule.onReqGetProfileAfterUpdateEmail = false;
        });
      }
    }
  }
}
