import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/logic/controller/pay_qris_bindings.dart';
import 'package:inisa_app/ui/screen/account/profile/profile_screen.dart';
import 'package:inisa_app/ui/screen/home/tooltips.dart';
import 'package:inisa_app/ui/screen/transaction/transaction_tab/transaction_tab.dart';
import 'package:inisa_app/ui/widget/message_box.dart';
import 'package:inisa_app/z_qoin/screen/pay/pay_screen_old.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/ui/screen/digital_id/select_id_type_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
// import 'package:venturo_mobile/agi/helper/constant/assets_constant.dart';
// import 'package:venturo_mobile/agi/ui/activation_screen/agi_access_screen.dart';
// import 'package:venturo_mobile/agi/ui/payment_screen/agi_qris_screen.dart';
// import 'package:venturo_mobile/otaqu/logic/controller/otaqu_controller.dart';
// import 'package:venturo_mobile/shared_inisa/controllers/subsidi_status_controller.dart';
// import 'package:venturo_mobile/shared_inisa/controllers/wallet_access_controller.dart';
// import 'package:venturo_mobile/shared_inisa/controllers/yukk_access_controller.dart';
// import 'package:venturo_mobile/shared_inisa/controllers/agi_connect_controller.dart';
// import 'package:venturo_mobile/shared_inisa/inisa_venturo_methods.dart';
// import 'package:venturo_mobile/yukk/ui/screens/yukk_inapp_webview_screen.dart';
// import 'package:venturo_mobile/yukk/ui/screens/yukk_pay_qris_screen.dart';

import 'home_tab.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final bool isRegister;
  final bool toTransaction;
  HomeScreen({this.isRegister = false, this.toTransaction = false});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TOOLTIPS
  TutorialCoachMark? tutorial;
  bool _currentlyShowing = false;

  GlobalKey addCardTutorialKey = GlobalKey();
  GlobalKey qoinCashKey = GlobalKey();
  GlobalKey qoinPoinKey = GlobalKey();
  GlobalKey allServicesKey = GlobalKey();
  GlobalKey scanButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // qoin.Get.put(YukkAccessController());
    // qoin.Get.put(AgiConnectController());
    // qoin.Get.put(WalletAccessController());
    // qoin.Get.put(SubsidiStatusController());
    // qoin.Get.put(OtaquController());

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        // InisaVenturoMethods.checkForceUpdateStatusAPI();

        qoin.AccountsController.instance.getProfile(
          onSuccess: () {},
          onError: (error) {
            if (error == 'relogin') {
              IntentTo.sessionExpired();
            }
          },
        );

        DigitalArchiveUIController.to.joinAllCard();

        // YukkAccessController.to.getYukkStatus(isInitData: true);

        // if (EnvironmentConfig.flavor != qoin.Flavor.Staging) {
        //   AgiConnectController.to.onGetAgiStatus();
        // }

        // WalletAccessController.to.checkStatusAccessWallet();

        qoin.VoucherTopupController.instance
            .fetchVoucherTopupPurchasedList()
            .then((value) {
          // qoin.OtaController.to
          //     .getListVoucher(
          //         onSuccess: () {},
          //         onProfileNotComplete: () {},
          //         onFailed: (error) {})
          //     .then((value) {
          //   DigitalArchiveUIController.to.joinAllCard();
          // }).catchError((error) {
          //   DigitalArchiveUIController.to.joinAllCard();
          // });
        }).catchError((error) {
          // qoin.OtaController.to
          //     .getListVoucher(
          //         onSuccess: () {},
          //         onProfileNotComplete: () {},
          //         onFailed: (error) {})
          //     .then((value) {
          //   DigitalArchiveUIController.to.joinAllCard();
          // }).catchError((error) {
          //   DigitalArchiveUIController.to.joinAllCard();
          // });
        });
        qoin.OtaController.to
            .getListTicketManifest(
                onSuccess: () {},
                onProfileNotComplete: () {},
                onFailed: (error) {})
            .then((value) {
          DigitalArchiveUIController.to.joinAllCard();
        }).catchError((error) {
          DigitalArchiveUIController.to.joinAllCard();
        });

        //* [TAKE OUT] RELAWAN JOKOWI
        //   InisaVenturoMethods.checkRelawanJokowiStatus();

        // InisaVenturoMethods.getDigitalisasiTni();
        // // InisaVenturoMethods.getOtaquTicket();
        // OtaquController.to.getOtaquTicket();

        // SubsidiStatusController.to.checkAndGetSubsidiData();

        // try {
        //   InisaVenturoMethods.getAllRiwayat(type: 'kk').then((value) {
        //     InisaVenturoMethods.getAllRiwayat(type: 'akta_kelahiran')
        //         .then((value) {
        //       DigitalArchiveUIController.to.joinAllCard();
        //     });
        //   });
        // } catch (e) {
        //   debugPrint("[QoinAccount][InisaVenturoMethods] error: $e");
        // }

        // try {
        //   InisaVenturoMethods.getVouchersBansos()
        //       .then((value) => DigitalArchiveUIController.to.joinAllCard());
        // } catch (e) {
        //   debugPrint(
        //       "[QoinAccount][InisaVenturoMethods] restore bansos error: $e");
        // }

        showTutorial();

        if (widget.toTransaction) {
          _tabController.animateTo(1);
        } else {
          qoin.QoinWalletController.to.getAssets();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);

    return WillPopScope(
      onWillPop: () async {
        if (_tabController.index != 0) {
          _tabController.animateTo(0);
        } else {
          if (!_currentlyShowing) {
            DialogUtils.showMainPopup(
              title: Localization.labelLogoutApps.tr,
              buttonMainFirst: true,
              description: Localization.areYouSure.tr,
              secondaryButtonText: Localization.yes.tr,
              secondaryButtonFunction: () => SystemNavigator.pop(),
              mainButtonText: Localization.no.tr,
              mainButtonFunction: () => qoin.Get.back(),
              mainPopupButtonDirection: MainPopupButtonDirection.Horizontal,
            );
          }
        }
        return false;
      },
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.light),
              elevation: 0,
            )),
        bottomSheet: Padding(
          padding: EdgeInsets.zero,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  HomeTab(
                    qoinCashKey: qoinCashKey,
                    qoinPoinKey: qoinPoinKey,
                    allServicesKey: allServicesKey,
                    addCardTutorialKey: addCardTutorialKey,
                  ),
                  TransactionTab(),
                  // Container(),
                  Container(),
                  Container(),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Stack(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: kBottomNavigationBarHeight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.w)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x1f000000),
                                offset: Offset(0, -3),
                                blurRadius: 3,
                                spreadRadius: 0),
                          ],
                          color: Colors.white),
                      child: Row(
                        children: [
                          _bottomDrawerItem(
                              0, Assets.icNewHome, Localization.homeTab1.tr),
                          _bottomDrawerItem(1, Assets.icNewTransaction,
                              Localization.homeTab2.tr),
                          Spacer(),
                          _bottomDrawerItem(
                              2, Assets.icNewPromo, Localization.homeTab4.tr,
                              onTap: () => DialogUtils.showComingSoonDrawer()),
                          _bottomDrawerItem(
                              3, Assets.icNewProfile, Localization.homeTab5.tr,
                              onTap: () => qoin.Get.to(() => ProfileScreen())),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: ScreenUtil().screenWidth,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.w),
                      width: kBottomNavigationBarHeight * 1.1,
                      height: kBottomNavigationBarHeight * 1.1,
                      child: MediaQuery.of(context).viewInsets.bottom > 0
                          ? SizedBox()
                          : FloatingActionButton(
                              key: scanButtonKey,
                              elevation: 0,
                              backgroundColor: ColorUI.secondary,
                              heroTag: "bottomFAB",
                              onPressed: () {
                                DialogUtils.showGeneralDrawer(
                                  withStrip: true,
                                  radius: 20,
                                  content: Container(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // if (WalletAccessController.to
                                            //     .getAccessWallet(whichWallet: 'inisa')
                                            //     .value) {
                                            //   if ((YukkAccessController.to.yukkToken.value == null)) {
                                            //     qoin.Get.back();
                                            //     qoin.Get.to(
                                            //       () => YukkInAppWebViewScreen(
                                            //         onSuccessConnectedYukk: () async {
                                            //           await YukkAccessController.to
                                            //               .getYukkStatus(isInitData: true);
                                            //           qoin.Get.back();
                                            //         },
                                            //       ),
                                            //       arguments: {
                                            //         "whichProcess": "connect",
                                            //       },
                                            //     );
                                            //   } else {
                                            //     qoin.Get.back();
                                            //     qoin.Get.to(YukkPayQrisScreen());
                                            //   }
                                            // } else {
                                            // chooseSumberDanaDrawer();
                                            // }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                Assets.payRed,
                                                height: 40.w,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        Localization
                                                            .homePayment.tr,
                                                        style: TextUI
                                                            .subtitleBlack),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        Localization
                                                            .homePaymentDesc.tr,
                                                        style: TextUI
                                                            .bodyText2Black)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          height: 1,
                                          color: Color(0xffdedede),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              qoin.Get.back();
                                              qoin.Get.to(
                                                  () => SelectIdTypeScreen());
                                              // DialogUtils.showComingSoonDrawer();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  Assets.addDigitalisasi,
                                                  height: 40.w,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        Localization
                                                            .homeDigitalization
                                                            .tr,
                                                        style: TextUI
                                                            .subtitleBlack,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        Localization
                                                            .homeDigitalizationDesc
                                                            .tr,
                                                        style: TextUI
                                                            .bodyText2Black,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: SafeArea(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Assets.icQRScan,
                                      height: 27.w,
                                      color: Colors.white,
                                    ),
                                    Text(Localization.homeTab3.tr,
                                        style: TextUI.labelWhite,
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _bottomDrawerItem(int index, String asset, String label,
          {GestureTapCallback? onTap}) =>
      Expanded(
        child: InkResponse(
          onTap: onTap ?? () => _tabController.animateTo(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                asset,
                color: _tabController.index == index
                    ? ColorUI.secondary
                    : qoin.Get.theme.unselectedWidgetColor,
                height: 27,
              ),
              Text(
                label,
                style: TextUI.labelBlack.copyWith(
                  color: _tabController.index == index
                      ? Colors.black
                      : ColorUI.text_3,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  void showTutorial() async {
    if (!(qoin.HiveData.homeTutorial ?? false)) {
      _currentlyShowing = true;
      await Future.delayed(Duration(milliseconds: 300));
      tutorial = TutorialCoachMark(
        context,
        targets: addHomeTutorialTarget(),
        hideSkip: true,
        onFinish: onSkip,
      )..show();
    }
  }

  onSkip() {
    _currentlyShowing = false;
    tutorial!.skip();
    qoin.HiveData.homeTutorial = true;
    if (widget.isRegister) {
      DialogUtils.showCompleteEmailDrawer();
    }
  }

  // void chooseSumberDanaDrawer() {
  //   DialogUtils.showGeneralDrawer(
  //     withStrip: false,
  //     radius: 20,
  //     content: Container(
  //       padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.w),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.all(4),
  //                 child: InkWell(
  //                   onTap: () => qoin.Get.back(),
  //                   child: Icon(
  //                     Icons.arrow_back_ios_rounded,
  //                     size: 18,
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 6,
  //               ),
  //               Text(
  //                 Localization.homeChoosePayment.tr,
  //                 style: TextUI.subtitleBlack,
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 12,
  //           ),
  //           qoin.Obx(
  //             () => Visibility(
  //               visible: !WalletAccessController.to
  //                   .getAccessWallet(whichWallet: 'inisa')
  //                   .value,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: ColorUI.border),
  //                 ),
  //                 padding: EdgeInsets.all(12),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     qoin.Get.back();
  //                     qoin.Get.back();
  //                     qoin.Get.to(PayScreenOld(), binding: PayQrisBindings());
  //                   },
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Image.asset(
  //                         Assets.inisaPayment,
  //                         height: 40.w,
  //                         fit: BoxFit.fitHeight,
  //                       ),
  //                       SizedBox(
  //                         width: 16,
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           QoinServicesLocalization.serviceTextQoinCash.tr,
  //                           style: TextUI.bodyText2Black,
  //                         ),
  //                       ),
  //                       Icon(
  //                         Icons.arrow_forward_ios_rounded,
  //                         size: 18,
  //                         color: ColorUI.disabled,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 12,
  //           ),
  //           qoin.Obx(
  //             () => Visibility(
  //               visible: !WalletAccessController.to
  //                   .getAccessWallet(whichWallet: 'yukk')
  //                   .value,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: ColorUI.border),
  //                 ),
  //                 padding: EdgeInsets.all(12),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     if ((YukkAccessController.to.yukkToken.value == null)) {
  //                       qoin.Get.back();
  //                       qoin.Get.back();
  //                       qoin.Get.to(
  //                         () => YukkInAppWebViewScreen(
  //                           onSuccessConnectedYukk: () async {
  //                             await YukkAccessController.to
  //                                 .getYukkStatus(isInitData: true);
  //                             qoin.Get.back();
  //                           },
  //                         ),
  //                         arguments: {
  //                           "whichProcess": "connect",
  //                         },
  //                       );
  //                     } else {
  //                       qoin.Get.back();
  //                       qoin.Get.back();
  //                       qoin.Get.to(YukkPayQrisScreen());
  //                     }
  //                   },
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Image.asset(
  //                         Assets.yukkPayment,
  //                         height: 40.w,
  //                         width: 40.w,
  //                         fit: BoxFit.fitWidth,
  //                       ),
  //                       SizedBox(
  //                         width: 16,
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           'YUKK Wallet',
  //                           style: TextUI.bodyText2Black,
  //                         ),
  //                       ),
  //                       (YukkAccessController.to.yukkToken.value == null)
  //                           ? Text(
  //                               'Aktivasi',
  //                               style: TextUI.bodyTextBlack.copyWith(
  //                                 color: ColorUI.qoinSecondary,
  //                                 fontSize: 14.sp,
  //                               ),
  //                             )
  //                           : Icon(
  //                               Icons.arrow_forward_ios_rounded,
  //                               size: 18,
  //                               color: ColorUI.disabled,
  //                             ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 12,
  //           ),
  //           qoin.Obx(
  //             () => Visibility(
  //               visible: !WalletAccessController.to
  //                   .getAccessWallet(whichWallet: 'agicash')
  //                   .value,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: ColorUI.border),
  //                 ),
  //                 padding: EdgeInsets.all(12),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     if (EnvironmentConfig.flavor != qoin.Flavor.Staging) {
  //                       if (AgiConnectController
  //                               .to.agiConnect.value!.isConnected ==
  //                           false) {
  //                         qoin.Get.back();
  //                         qoin.Get.back();
  //                         qoin.Get.to(() => AgiAccessScreen());
  //                       } else {
  //                         qoin.Get.back();
  //                         qoin.Get.back();
  //                         qoin.Get.to(() => AgiQrisScreen());
  //                       }
  //                     }
  //                   },
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Image.asset(
  //                         AssetsConstant.icAgiNoTitle,
  //                         height: 40.w,
  //                         width: 40.w,
  //                         package: 'venturo_mobile',
  //                         fit: BoxFit.fitWidth,
  //                       ),
  //                       SizedBox(
  //                         width: 16,
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           'AGI Cash',
  //                           style: TextUI.bodyText2Black,
  //                         ),
  //                       ),
  //                       if (EnvironmentConfig.flavor != qoin.Flavor.Staging)
  //                         (AgiConnectController
  //                                     .to.agiConnect.value!.isConnected ==
  //                                 false)
  //                             ? Text(
  //                                 'Aktivasi',
  //                                 style: TextUI.bodyTextBlack.copyWith(
  //                                   color: ColorUI.qoinSecondary,
  //                                   fontSize: 14.sp,
  //                                 ),
  //                               )
  //                             : Icon(
  //                                 Icons.arrow_forward_ios_rounded,
  //                                 size: 18,
  //                                 color: ColorUI.disabled,
  //                               ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  List<TargetFocus> addHomeTutorialTarget() {
    return <TargetFocus>[
      TargetFocus(
        identify: "addCardTutorial",
        keyTarget: addCardTutorialKey,
        radius: 10.0,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            padding: EdgeInsets.only(left: 16.w),
            align: ContentAlign.bottom,
            child: MessageBox(
              alignAngel: AlignAngel.topLeft,
              title: Localization.homeTips1.tr,
              description: Localization.homeTips1Desc.tr,
              onSkipPressed: onSkip,
              onActionPressed: () {
                tutorial!.next();
              },
              tutorialCount: 5,
              tutorialActiveIndex: 0,
            ),
          ),
        ],
      ),
      // TargetFocus(
      //   identify: "qoinCash",
      //   keyTarget: qoinCashKey,
      //   shape: ShapeLightFocus.RRect,
      //   radius: 10.0,
      //   paddingFocus: 5.0,
      //   contents: [
      //     TargetContent(
      //       align: ContentAlign.top,
      //       child: MessageBox(
      //         alignAngel: AlignAngel.bottomLeft,
      //         title: Localization.homeTips2.tr,
      //         description: Localization.homeTips2Desc.tr,
      //         onSkipPressed: onSkip,
      //         onActionPressed: () {
      //           tutorial!.next();
      //         },
      //         tutorialCount: 5,
      //         tutorialActiveIndex: 1,
      //       ),
      //     ),
      //   ],
      // ),
      TargetFocus(
        identify: "qoinPoin",
        keyTarget: qoinPoinKey,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        paddingFocus: 5.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: MessageBox(
              alignAngel: AlignAngel.bottomRight,
              title: Localization.homeTips3.tr,
              description: Localization.homeTips3Desc.tr,
              onSkipPressed: onSkip,
              onActionPressed: () {
                tutorial!.next();
              },
              tutorialCount: 5,
              tutorialActiveIndex: 2,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "allServices",
        keyTarget: allServicesKey,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        paddingFocus: 5.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: MessageBox(
              alignAngel: AlignAngel.bottomRight,
              title: Localization.homeTips4.tr,
              description: Localization.homeTips4Desc.tr,
              onSkipPressed: onSkip,
              onActionPressed: () {
                tutorial!.next();
              },
              tutorialCount: 5,
              tutorialActiveIndex: 3,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "scanButton",
        keyTarget: scanButtonKey,
        radius: 30.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: MessageBox(
              alignAngel: AlignAngel.bottomCenter,
              title: Localization.homeTips5.tr,
              description: Localization.homeTips5Desc.tr,
              actionText: Localization.finish.tr,
              onActionPressed: () {
                _currentlyShowing = false;
                qoin.HiveData.homeTutorial = true;
                tutorial!.next();
              },
              tutorialCount: 5,
              tutorialActiveIndex: 4,
            ),
          ),
        ],
      ),
    ];
  }
}
