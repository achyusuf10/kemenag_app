import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/logic/controller/pay_qris_bindings.dart';
import 'package:inisa_app/ui/screen/transaction/transaction_tab/transaction_page.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/message_box.dart';
import 'package:inisa_app/ui/widget/powerbyqoin.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'pay/pay_screen_old.dart';
import 'request/pay_me/pay_me_screen.dart';
import 'request/split_bill/split_bill_screen.dart';
import 'topup/topup_screen.dart';
import 'transfer/transfer_screen.dart';

class WalletScreen extends StatefulWidget {
  final bool fromTransaction;
  const WalletScreen({this.fromTransaction = false});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // TOOLTIPS
  TutorialCoachMark? tutorial;
  bool _currentlyShowing = false;

  GlobalKey payKey = GlobalKey();
  GlobalKey topUpKey = GlobalKey();
  GlobalKey transferKey = GlobalKey();
  GlobalKey askMoneyKey = GlobalKey();

  @override
  void initState() {
    showTutorial();
    super.initState();
    if (!widget.fromTransaction) {
      qoin.QoinTransactionController.to.getHistoryData(0).then((value) {
        qoin.QoinWalletController.to.getAssets();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_currentlyShowing) {
          qoin.Get.back();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBarWidget.qoin(
          title: QoinServicesLocalization.serviceTextQoinCash.tr,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 110.h,
                    color: Colors.black,
                  ),
                  Container(width: double.infinity, height: 24.h, color: ColorUI.qoinSecondary)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      // controller.getAssets();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      // color: QoinWallet.theme.primaryColor,
                      child: Column(
                        children: [
                          qoin.GetBuilder<qoin.QoinWalletController>(builder: (controller) {
                            return Text(
                              "Rp${qoin.QoinWalletController.to.balance}",
                              style: TextUI.header2Black.copyWith(color: ColorUI.qoinSecondary, fontSize: 28.sp),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: ColorUI.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x14111111),
                          offset: Offset(0, -2),
                          blurRadius: 16,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          key: payKey,
                          child: InkWell(
                            onTap: () {
                              if (qoin.QoinRemoteConfigController.instance.isQrisActive == true) {
                                qoin.Get.to(PayScreenOld(), binding: PayQrisBindings());
                                // qoin.Get.to(PayScreen(), binding: PayQrisBindings());
                              } else {
                                DialogUtils.showComingSoonDrawer();
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  Assets.icPay,
                                  height: 40.w,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(WalletLocalization.menuPay.tr,
                                    style: TextUI.bodyText2Black, textAlign: TextAlign.center)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          key: topUpKey,
                          child: InkWell(
                            onTap: () {
                              if (qoin.QoinRemoteConfigController.instance.isTopupActive == true) {
                                qoin.Get.to(TopUpScreen());
                              } else {
                                DialogUtils.showComingSoonDrawer();
                              }
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  Assets.icTopup,
                                  height: 40,
                                  width: 40,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(WalletLocalization.menuTopup.tr,
                                    style: TextUI.bodyText2Black, textAlign: TextAlign.center)
                              ],
                            ),
                          ),
                        ),
                        // Expanded(
                        //   key: transferKey,
                        //   child: InkWell(
                        //     onTap: () {
                        //       if (qoin.QoinRemoteConfigController.instance.isTransferActive == true) {
                        //         qoin.Get.to(TransferScreen());
                        //       } else {
                        //         DialogUtils.showComingSoonDrawer();
                        //       }
                        //     },
                        //     child: Column(
                        //       children: [
                        //         Image.asset(
                        //           Assets.icMenuTransfer,
                        //           height: 40,
                        //           width: 40,
                        //         ),
                        //         SizedBox(
                        //           height: 4,
                        //         ),
                        //         Text(WalletLocalization.menuTransfer.tr,
                        //             style: TextUI.bodyText2Black, textAlign: TextAlign.center)
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Expanded(
                        //   key: askMoneyKey,
                        //   child: InkWell(
                        //     onTap: () {
                        //       DialogUtils.showGeneralDrawer(
                        //           withStrip: true,
                        //           radius: 24.r,
                        //           content: Column(
                        //             children: [
                        //               Text(
                        //                 WalletLocalization.menuRequestFund.tr,
                        //                 style: TextUI.title2Black,
                        //               ),
                        //               SizedBox(
                        //                 height: 24.w,
                        //               ),
                        //               ListTile(
                        //                 onTap: () {
                        //                   if (qoin.QoinRemoteConfigController.instance.isFundRequestPayme) {
                        //                     qoin.Get.back();
                        //                     qoin.Get.to(PayMeScreen());
                        //                   } else {
                        //                     DialogUtils.showComingSoonDrawer();
                        //                   }
                        //                 },
                        //                 title: Text(
                        //                   WalletLocalization.subMenuPayMe.tr,
                        //                   style: TextUI.bodyTextBlack,
                        //                 ),
                        //                 leading: Image.asset(
                        //                   Assets.icPayMe,
                        //                   height: 32.w,
                        //                   fit: BoxFit.fitHeight,
                        //                 ),
                        //                 trailing: Icon(
                        //                   Icons.arrow_forward_ios,
                        //                   color: Colors.grey,
                        //                   size: 16.w,
                        //                 ),
                        //               ),
                        //               Divider(),
                        //               ListTile(
                        //                 onTap: () {
                        //                   if (qoin.QoinRemoteConfigController.instance.isFundRequestSeparateBill) {
                        //                     qoin.Get.back();
                        //                     qoin.Get.to(SplitBillScreen());
                        //                   } else {
                        //                     DialogUtils.showComingSoonDrawer();
                        //                   }
                        //                 },
                        //                 title:
                        //                     Text(WalletLocalization.subMenuSplitBill.tr, style: TextUI.bodyTextBlack),
                        //                 leading: Image.asset(
                        //                   Assets.icSplitBill,
                        //                   height: 32.w,
                        //                   fit: BoxFit.fitHeight,
                        //                 ),
                        //                 trailing: Icon(
                        //                   Icons.arrow_forward_ios,
                        //                   color: Colors.grey,
                        //                   size: 16.w,
                        //                 ),
                        //               ),
                        //               Divider(),
                        //             ],
                        //           ));
                        //     },
                        //     child: Column(
                        //       children: [
                        //         Image.asset(
                        //           Assets.icMenuReceive,
                        //           height: 40,
                        //           width: 40,
                        //         ),
                        //         SizedBox(
                        //           height: 4,
                        //         ),
                        //         Text(WalletLocalization.menuRequestFund.tr,
                        //             style: TextUI.bodyText2Black, textAlign: TextAlign.center)
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 12),
                    child: Text(
                      WalletLocalization.historyTransaction.tr,
                      style: TextUI.title2Black,
                    ),
                  ),
                  Expanded(
                    child: TransactionPage(
                      tabIndex: -1,
                      isQoin: true,
                      isFromWallet: true,
                    ),
                  ),
                  // PoweredByQoin()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTutorial() async {
    if (!(qoin.HiveData.walletTutorial ?? false)) {
      _currentlyShowing = true;
      await Future.delayed(Duration(milliseconds: 300));
      tutorial = TutorialCoachMark(
        context,
        targets: addWalletTutorialTarget(),
        hideSkip: true,
        onFinish: onSkip,
      )..show();
    }
    // _currentlyShowing = true;
    // await Future.delayed(Duration(milliseconds: 1000));
    // tutorial = TutorialCoachMark(
    //   context,
    //   targets: addWalletTutorialTarget(),
    //   hideSkip: true,
    //   onFinish: onSkip,
    // )..show();
  }

  onSkip() {
    _currentlyShowing = false;
    tutorial!.skip();
    qoin.HiveData.walletTutorial = true;
  }

  List<TargetFocus> addWalletTutorialTarget() {
    return <TargetFocus>[
      TargetFocus(
        identify: "pay",
        keyTarget: payKey,
        shape: ShapeLightFocus.RRect,
        paddingFocus: 5.0,
        radius: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: MessageBox(
              alignAngel: AlignAngel.topLeft,
              title: WalletLocalization.toolTipWallet1Title.tr,
              description: WalletLocalization.toolTipWallet1Desc.tr,
              onSkipPressed: onSkip,
              onActionPressed: () {
                tutorial!.next();
              },
              tutorialCount: 4,
              tutorialActiveIndex: 0,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "topUp",
        keyTarget: topUpKey,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        paddingFocus: 5.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: MessageBox(
              alignAngel: AlignAngel.leftTop,
              title: WalletLocalization.toolTipWallet2Title.tr,
              description: WalletLocalization.toolTipWallet2Desc.tr,
              onSkipPressed: onSkip,
              onActionPressed: () {
                tutorial!.next();
              },
              tutorialCount: 4,
              tutorialActiveIndex: 1,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "transfer",
        keyTarget: transferKey,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        paddingFocus: 5.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: MessageBox(
              alignAngel: AlignAngel.rightTop,
              title: WalletLocalization.toolTipWallet3Title.tr,
              description: WalletLocalization.toolTipWallet3Desc.tr,
              onSkipPressed: onSkip,
              onActionPressed: () {
                tutorial!.next();
              },
              tutorialCount: 4,
              tutorialActiveIndex: 2,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "askDana",
        keyTarget: askMoneyKey,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        paddingFocus: 5.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: MessageBox(
              alignAngel: AlignAngel.topRight,
              title: WalletLocalization.toolTipWallet4Title.tr,
              description: WalletLocalization.toolTipWallet4Desc.tr,
              onActionPressed: () {
                tutorial!.next();
                qoin.HiveData.walletTutorial = true;
                _currentlyShowing = false;
              },
              actionText: WalletLocalization.finish.tr,
              tutorialCount: 4,
              tutorialActiveIndex: 3,
            ),
          ),
        ],
      ),
    ];
  }
}
