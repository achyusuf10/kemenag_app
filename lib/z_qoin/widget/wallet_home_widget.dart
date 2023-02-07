import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/logic/controller/pay_qris_bindings.dart';
import 'package:inisa_app/z_qoin/screen/pay/pay_screen_old.dart';
import 'package:inisa_app/z_qoin/screen/poin/qoin_poin_screen.dart';
import 'package:inisa_app/z_qoin/screen/wallet_screen.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:venturo_mobile/agi/helper/constant/assets_constant.dart';
// import 'package:venturo_mobile/agi/ui/activation_screen/agi_access_screen.dart';
// import 'package:venturo_mobile/agi/ui/payment_screen/agi_qris_screen.dart';
// import 'package:venturo_mobile/shared_inisa/controllers/wallet_access_controller.dart';
// import 'package:venturo_mobile/shared_inisa/controllers/yukk_access_controller.dart';
// import 'package:venturo_mobile/yukk/ui/screens/yukk_inapp_webview_screen.dart';
// import 'package:venturo_mobile/yukk/ui/screens/yukk_pay_qris_screen.dart';
// import 'package:venturo_mobile/shared_inisa/controllers/agi_connect_controller.dart';

class WalletHomeWidget extends StatelessWidget {
  const WalletHomeWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class WalletData {
//   static qoin.RxBool isVisible = false.obs;
//   static var icVisible = Assets.icVisible.obs;

//   static var currentIndex = 0.obs;
// }

// // ignore: must_be_immutable
// class WalletHomeWidget extends StatelessWidget {
//   // qoin.RxBool isVisible = true.obs;
//   // var icVisible = Assets.icVisibleOff.obs;
//   GlobalKey? qoinCashKey;
//   GlobalKey? qoinPoinKey;

//   WalletHomeWidget({this.qoinCashKey, this.qoinPoinKey});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: qoin.Get.theme.colorScheme.primary,
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Obx(
//             () => (WalletAccessController.to.isLoadingWalletAccess.isTrue)
//                 ? Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 12,
//                       ),
//                       child: Shimmer.fromColors(
//                         baseColor: Colors.transparent,
//                         highlightColor: Colors.grey.shade100,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           child: Container(
//                             color: Colors.white.withOpacity(0.5),
//                             height: 55.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : Expanded(
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 6),
//                           child: Column(
//                             children: [
//                               for (var i = 0;
//                                   i <
//                                       WalletAccessController
//                                           .to.listWalletWidget.length;
//                                   i++)
//                                 Column(
//                                   children: [
//                                     Container(
//                                       height: 8,
//                                       width: 2,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(4),
//                                         color:
//                                             (WalletData.currentIndex.value == i)
//                                                 ? ColorUI.qoinSecondary
//                                                 : ColorUI.text_4,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                   ],
//                                 ),
//                             ],

//                             // [
//                             //   if (WalletAccessController.to.getAccessWallet(whichWallet: 'yukk').value ==
//                             //       false)
//                             //     Column(
//                             //       children: [
//                             //         Container(
//                             //           height: 8,
//                             //           width: 2,
//                             //           decoration: BoxDecoration(
//                             //             borderRadius: BorderRadius.circular(4),
//                             //             color: (WalletData.currentIndex.value == 0)
//                             //                 ? ColorUI.qoinSecondary
//                             //                 : ColorUI.text_4,
//                             //           ),
//                             //         ),
//                             //         SizedBox(
//                             //           height: 2,
//                             //         ),
//                             //       ],
//                             //     ),
//                             //   Column(
//                             //     children: [
//                             //       Container(
//                             //         height: 8,
//                             //         width: 2,
//                             //         decoration: BoxDecoration(
//                             //           borderRadius: BorderRadius.circular(4),
//                             //           color: (WalletData.currentIndex.value == 1)
//                             //               ? ColorUI.qoinSecondary
//                             //               : ColorUI.text_4,
//                             //         ),
//                             //       ),
//                             //       SizedBox(
//                             //         height: 2,
//                             //       ),
//                             //     ],
//                             //   ),
//                             //   if (WalletAccessController.to.getAccessWallet(whichWallet: 'inisa').value ==
//                             //       false)
//                             //     Column(
//                             //       children: [
//                             //         Container(
//                             //           height: 8,
//                             //           width: 2,
//                             //           decoration: BoxDecoration(
//                             //             borderRadius: BorderRadius.circular(4),
//                             //             color: (WalletData.currentIndex.value == 2)
//                             //                 ? ColorUI.qoinSecondary
//                             //                 : ColorUI.text_4,
//                             //           ),
//                             //         ),
//                             //         SizedBox(
//                             //           height: 2,
//                             //         ),
//                             //       ],
//                             //     ),
//                             // ],
//                           ),
//                         ),
//                         Expanded(
//                           child: CarouselSlider(
//                             options: CarouselOptions(
//                               height: 75,
//                               initialPage: WalletData.currentIndex.value,
//                               scrollDirection: Axis.vertical,
//                               viewportFraction: 1,
//                               enlargeCenterPage: false,
//                               enableInfiniteScroll: false,
//                               onPageChanged: (index, reason) {
//                                 WalletData.currentIndex.value = index;
//                               },
//                             ),
//                             items: WalletAccessController.to.listWalletWidget,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//           Column(
//             children: [
//               Container(height: 12.w, width: 2, color: ColorUI.white),
//               InkWell(
//                 onTap: () {
//                   // if (WalletAccessController.to.getAccessWallet(whichWallet: 'inisa').value) {
//                   //   if ((YukkAccessController.to.yukkToken.value == null)) {
//                   //     qoin.Get.to(
//                   //       () => YukkInAppWebViewScreen(
//                   //         onSuccessConnectedYukk: () async {
//                   //           await YukkAccessController.to.getYukkStatus(isInitData: true);
//                   //           qoin.Get.back();
//                   //         },
//                   //       ),
//                   //       arguments: {
//                   //         "whichProcess": "connect",
//                   //       },
//                   //     );
//                   //   } else {
//                   //     qoin.Get.to(YukkPayQrisScreen());
//                   //   }
//                   // } else {
//                   chooseSumberDanaDrawer();
//                   // }
//                 },
//                 // onDoubleTap: () {
//                 //   DialogUtils.showGeneralDrawer(
//                 //     radius: 24,
//                 //     withStrip: true,
//                 //     content: Container(
//                 //       padding: EdgeInsets.only(right: 16, left: 16),
//                 //       width: double.infinity,
//                 //       child: Column(
//                 //         children: [
//                 //           Container(
//                 //             alignment: Alignment.center,
//                 //             child: Text.rich(
//                 //               TextSpan(
//                 //                 children: [
//                 //                   TextSpan(
//                 //                     text: 'Gimana Pengalamanmu\nMenggunakan',
//                 //                   ),
//                 //                   TextSpan(
//                 //                     text: ' INISA',
//                 //                     style: TextStyle(
//                 //                       fontSize: 16.sp,
//                 //                       fontWeight: FontWeight.w500,
//                 //                       color: ColorUI.secondary,
//                 //                     ),
//                 //                   ),
//                 //                 ],
//                 //               ),
//                 //               textAlign: TextAlign.center,
//                 //               style: TextStyle(
//                 //                 fontSize: 16.sp,
//                 //                 fontWeight: FontWeight.w500,
//                 //                 color: ColorUI.text_1,
//                 //               ),
//                 //             ),
//                 //           ),
//                 //           SizedBox(
//                 //             height: 16,
//                 //           ),
//                 //           Row(
//                 //             children: [
//                 //               Expanded(
//                 //                 flex: 1,
//                 //                 child: Container(
//                 //                   height: 160.h,
//                 //                   padding: EdgeInsets.all(10),
//                 //                   decoration: BoxDecoration(
//                 //                     border: Border.all(
//                 //                       color: ColorUI.border,
//                 //                     ),
//                 //                     borderRadius: BorderRadius.circular(10),
//                 //                   ),
//                 //                   child: Column(
//                 //                     crossAxisAlignment:
//                 //                         CrossAxisAlignment.center,
//                 //                     mainAxisAlignment: MainAxisAlignment.center,
//                 //                     children: [
//                 //                       Expanded(
//                 //                         child: Image.asset(
//                 //                           'assets/images/dialog/popup_failed.png',
//                 //                           fit: BoxFit.fitHeight,
//                 //                         ),
//                 //                       ),
//                 //                       SizedBox(
//                 //                         height: 14,
//                 //                       ),
//                 //                       Text(
//                 //                         'Kurang OK nih! :(',
//                 //                         style: TextStyle(
//                 //                           fontSize: 12.sp,
//                 //                           fontWeight: FontWeight.normal,
//                 //                           color: ColorUI.secondary,
//                 //                         ),
//                 //                       ),
//                 //                     ],
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //               SizedBox(
//                 //                 width: 20,
//                 //               ),
//                 //               Expanded(
//                 //                 flex: 1,
//                 //                 child: Container(
//                 //                   height: 160.h,
//                 //                   padding: EdgeInsets.all(10),
//                 //                   decoration: BoxDecoration(
//                 //                     border: Border.all(
//                 //                       color: ColorUI.border,
//                 //                     ),
//                 //                     borderRadius: BorderRadius.circular(10),
//                 //                   ),
//                 //                   child: Column(
//                 //                     crossAxisAlignment:
//                 //                         CrossAxisAlignment.center,
//                 //                     mainAxisAlignment: MainAxisAlignment.center,
//                 //                     children: [
//                 //                       Expanded(
//                 //                         child: Image.asset(
//                 //                           'assets/images/dialog/successGreen.png',
//                 //                           fit: BoxFit.fitHeight,
//                 //                         ),
//                 //                       ),
//                 //                       SizedBox(
//                 //                         height: 14,
//                 //                       ),
//                 //                       Text(
//                 //                         'Mantap Banget! :)',
//                 //                         style: TextStyle(
//                 //                           fontSize: 12.sp,
//                 //                           fontWeight: FontWeight.normal,
//                 //                           color: ColorUI.text_1,
//                 //                         ),
//                 //                       ),
//                 //                     ],
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //           SizedBox(
//                 //             height: 16,
//                 //           ),
//                 //           InkWell(
//                 //             onTap: () => Get.back(),
//                 //             child: Container(
//                 //               alignment: Alignment.center,
//                 //               child: Text(
//                 //                 'Lewati',
//                 //                 style: TextStyle(
//                 //                   fontSize: 16.sp,
//                 //                   fontWeight: FontWeight.w500,
//                 //                   color: ColorUI.text_3,
//                 //                 ),
//                 //               ),
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   );
//                 // },
//                 child: Container(
//                   padding: EdgeInsets.all(12.w),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white),
//                     borderRadius: BorderRadius.circular(28.r),
//                   ),
//                   child: Image.asset(
//                     Assets.icPayHome,
//                     height: 24.w,
//                     fit: BoxFit.fitHeight,
//                   ),
//                 ),
//               ),
//               Container(height: 12.w, width: 2, color: ColorUI.white)
//             ],
//           ),
//           Expanded(
//             key: qoinPoinKey,
//             child: InkWell(
//               onTap: () {
//                 if (EnvironmentConfig.flavor == qoin.Flavor.Production) {
//                   DialogUtils.showComingSoonDrawer();
//                 } else {
//                   qoin.Get.to(() => QoinPoinScreen());
//                 }
//               },
//               child: Padding(
//                 padding: EdgeInsets.all(16.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           "Poin ",
//                           style: TextUI.labelWhite,
//                         ),
//                         Image.asset(
//                           Assets.icPoints,
//                           width: 15.w,
//                         ),
//                       ],
//                     ),
//                     qoin.GetBuilder<qoin.QoinWalletController>(
//                         builder: (controller) {
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             controller.point,
//                             style: TextUI.bodyTextWhite,
//                           ),
//                         ],
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   toggleShowBalance() {
//     WalletData.isVisible.value = !WalletData.isVisible.value;
//     if (WalletData.isVisible.value) {
//       WalletData.icVisible.value = Assets.icVisibleOff;
//     } else {
//       WalletData.icVisible.value = Assets.icVisible;
//     }
//     print("is visible ${WalletData.isVisible.value}");
//   }

//   Widget inisaSaldoWalletWidget() {
//     return InkWell(
//       onTap: () {
//         qoin.Get.to(WalletScreen());
//       },
//       child: Container(
//         padding: EdgeInsets.all(16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Image.asset(
//                   Assets.icInisaWallet,
//                   height: 16.w,
//                   width: 16.w,
//                 ),
//                 Text(
//                   "  ${QoinServicesLocalization.serviceTextQoinCash.tr}  ",
//                   style: TextUI.labelWhite,
//                 ),
//                 InkWell(
//                   onTap: () => toggleShowBalance(),
//                   child: qoin.Obx(
//                     () => Image.asset(
//                       WalletData.icVisible.value,
//                       width: 15.w,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             qoin.GetBuilder<qoin.QoinWalletController>(builder: (controller) {
//               return qoin.Obx(
//                 () => Text(
//                   "Rp ${(WalletData.isVisible.value) ? qoin.QoinWalletController.to.balance : '*******'}",
//                   //"Rp${qoin.QoinWalletController.to.balance ?? '0'}",
//                   style: TextUI.bodyTextWhite,
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget yukkWalletWidget() {
//     return Obx(
//       () => InkWell(
//         onTap: () {
//           YukkAccessController.to.getYukkStatus();
//         },
//         child: Container(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Image(
//                     image: AssetImage(Assets.logoYukkMini),
//                     width: 23.w,
//                     height: 23.w,
//                   ),
//                   Text(
//                     "  YUKK Cash ",
//                     style: TextUI.labelWhite,
//                   ),
//                 ],
//               ),
//               (YukkAccessController.to.isLoadingYukkStatus.isTrue)
//                   ? Text(
//                       'Loading...',
//                       textScaleFactor: 1,
//                       style: TextUI.bodyTextBlack.copyWith(
//                         color: ColorUI.qoinSecondary,
//                         fontSize: 13,
//                         decoration: TextDecoration.underline,
//                       ),
//                     )
//                   : Text(
//                       (YukkAccessController.to.yukkToken.value == null)
//                           ? "Aktivasi"
//                           : "Rp ${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(YukkAccessController.to.yukkBalance.value!)}",
//                       textScaleFactor: 1,
//                       style: TextUI.bodyTextBlack.copyWith(
//                         color: (YukkAccessController.to.yukkToken.value == null)
//                             ? ColorUI.qoinSecondary
//                             : ColorUI.white,
//                         fontSize: 13,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget agiCashWidget() {
//     return Obx(
//       () => InkWell(
//         onTap: (EnvironmentConfig.flavor == qoin.Flavor.Staging)
//             ? null
//             : AgiConnectController.to.onTapAgiWallet,
//         child: Container(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Image.asset(
//                     AssetsConstant.icAgiNoTitle,
//                     width: 23.w,
//                     package: 'venturo_mobile',
//                   ),
//                   Text(
//                     "  AGI Cash ",
//                     style: TextUI.labelWhite,
//                   ),
//                 ],
//               ),
//               if (EnvironmentConfig.flavor != qoin.Flavor.Staging)
//                 (AgiConnectController.to.isLoadingAgiStatus.isTrue)
//                     ? Text(
//                         'Loading...',
//                         textScaleFactor: 1,
//                         style: TextUI.bodyTextBlack.copyWith(
//                           color: ColorUI.qoinSecondary,
//                           fontSize: 13,
//                           decoration: TextDecoration.underline,
//                         ),
//                       )
//                     : (AgiConnectController.to.agiConnect.value!.isConnected ==
//                             false)
//                         ? Text(
//                             "Aktivasi",
//                             textScaleFactor: 1,
//                             style: TextUI.bodyTextBlack.copyWith(
//                               color: ColorUI.qoinSecondary,
//                               fontSize: 13,
//                               decoration: TextDecoration.underline,
//                             ),
//                           )
//                         : Text(
//                             "Rp ${NumberFormat.currency(
//                               locale: "id",
//                               symbol: "",
//                               decimalDigits: 0,
//                             ).format(
//                               AgiConnectController.to.agiBalance.value,
//                             )}",
//                             textScaleFactor: 1,
//                             style: TextUI.bodyTextBlack.copyWith(
//                               color: ColorUI.qoinSecondary,
//                               fontSize: 13,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//               if (EnvironmentConfig.flavor == qoin.Flavor.Staging)
//                 Text(
//                   (AgiConnectController.to.agiBalance.toString() == '0')
//                       ? '-'
//                       : '-',
//                   textScaleFactor: 1,
//                   style: TextUI.bodyTextBlack.copyWith(
//                     color: ColorUI.qoinSecondary,
//                     fontSize: 13,
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void chooseSumberDanaDrawer() {
//     DialogUtils.showGeneralDrawer(
//       withStrip: false,
//       radius: 20,
//       content: Container(
//         padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(4),
//                   child: InkWell(
//                     onTap: () => qoin.Get.back(),
//                     child: Icon(
//                       Icons.arrow_back_ios_rounded,
//                       size: 18,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 6,
//                 ),
//                 Text(
//                   Localization.homeChoosePayment.tr,
//                   style: TextUI.subtitleBlack,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             Obx(
//               () => Visibility(
//                 visible: !WalletAccessController.to
//                     .getAccessWallet(whichWallet: 'inisa')
//                     .value,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: ColorUI.border),
//                   ),
//                   padding: EdgeInsets.all(12),
//                   child: GestureDetector(
//                     onTap: () {
//                       qoin.Get.back();
//                       qoin.Get.to(PayScreenOld(), binding: PayQrisBindings());
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           Assets.inisaPayment,
//                           height: 40.w,
//                           fit: BoxFit.fitHeight,
//                         ),
//                         SizedBox(
//                           width: 16,
//                         ),
//                         Expanded(
//                           child: Text(
//                             'Saldo',
//                             style: TextUI.bodyText2Black,
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           size: 18,
//                           color: ColorUI.disabled,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             Obx(
//               () => Visibility(
//                 visible: !WalletAccessController.to
//                     .getAccessWallet(whichWallet: 'yukk')
//                     .value,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: ColorUI.border),
//                   ),
//                   padding: EdgeInsets.all(12),
//                   child: GestureDetector(
//                     onTap: () {
//                       if ((YukkAccessController.to.yukkToken.value == null)) {
//                         qoin.Get.back();
//                         qoin.Get.to(
//                           () => YukkInAppWebViewScreen(
//                             onSuccessConnectedYukk: () async {
//                               await YukkAccessController.to
//                                   .getYukkStatus(isInitData: true);
//                               qoin.Get.back();
//                             },
//                           ),
//                           arguments: {
//                             "whichProcess": "connect",
//                           },
//                         );
//                       } else {
//                         qoin.Get.back();
//                         qoin.Get.to(YukkPayQrisScreen());
//                       }
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           Assets.yukkPayment,
//                           height: 40.w,
//                           width: 40.w,
//                           fit: BoxFit.fitWidth,
//                         ),
//                         SizedBox(
//                           width: 16,
//                         ),
//                         Expanded(
//                           child: Text(
//                             'YUKK Wallet',
//                             style: TextUI.bodyText2Black,
//                           ),
//                         ),
//                         (YukkAccessController.to.yukkToken.value == null)
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
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             Obx(
//               () => Visibility(
//                 visible: !WalletAccessController.to
//                     .getAccessWallet(whichWallet: 'agicash')
//                     .value,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: ColorUI.border),
//                   ),
//                   padding: EdgeInsets.all(12),
//                   child: GestureDetector(
//                     onTap: () {
//                       if (EnvironmentConfig.flavor != qoin.Flavor.Staging) {
//                         if (AgiConnectController
//                                 .to.agiConnect.value!.isConnected ==
//                             false) {
//                           qoin.Get.back();
//                           qoin.Get.to(() => AgiAccessScreen());
//                         } else {
//                           qoin.Get.back();
//                           qoin.Get.to(() => AgiQrisScreen());
//                         }
//                       }
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           AssetsConstant.icAgiNoTitle,
//                           height: 40.w,
//                           width: 40.w,
//                           package: 'venturo_mobile',
//                           fit: BoxFit.fitWidth,
//                         ),
//                         SizedBox(
//                           width: 16,
//                         ),
//                         Expanded(
//                           child: Text(
//                             'AGI Cash',
//                             style: TextUI.bodyText2Black,
//                           ),
//                         ),
//                         if (EnvironmentConfig.flavor != qoin.Flavor.Staging)
//                           (AgiConnectController
//                                       .to.agiConnect.value!.isConnected ==
//                                   false)
//                               ? Text(
//                                   'Aktivasi',
//                                   style: TextUI.bodyTextBlack.copyWith(
//                                     color: ColorUI.qoinSecondary,
//                                     fontSize: 14.sp,
//                                   ),
//                                 )
//                               : Icon(
//                                   Icons.arrow_forward_ios_rounded,
//                                   size: 18,
//                                   color: ColorUI.disabled,
//                                 ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
