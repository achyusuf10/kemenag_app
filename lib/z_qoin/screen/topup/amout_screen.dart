import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/money_choice_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/z_qoin/model/wallet_model.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:shimmer/shimmer.dart';
import 'bank_transfer/virtual_account_screen.dart';

class AmountScreen extends StatefulWidget {
  Bank? bank;

  AmountScreen({Key? key, this.bank}) : super(key: key);

  @override
  _AmountScreenState createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  List<String> images = [
    Assets.uang1,
    Assets.uang2,
    Assets.uang3,
    Assets.uang4,
    Assets.uang5,
    Assets.uang6
  ];

  var selected = 0.obs;
  var valueNominal = ''.obs;
  var valueNominalController = TextEditingController(text: '').obs;
  var valueTopUp = 0.obs;

  @override
  void initState() {
    super.initState();
    QoinWalletController.to.getDenomNTT(onSuccess: () {}, onError: (error) {});
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: QoinWalletController.to.isLoadingGetVa.stream,
      child: Scaffold(
        backgroundColor: ColorUI.shape,
        appBar: AppBarWidget.qoin(
          title: WalletLocalization.menuTopup.tr,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                WalletLocalization.topUpSelectNominal.tr,
                style: TextUI.title2Black,
              ),
              SizedBox(
                height: 16.0,
              ),
              GetBuilder<QoinWalletController>(builder: (controller) {
                return Container(
                  child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2),
                      children: controller.isMainLoading.value
                          ? List.generate(
                              6,
                              (index) => Shimmer.fromColors(
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100))
                          : controller.denomList
                              .map(
                                (e) => MoneyChoiceWidget(
                                  bgColor: Colors.white,
                                  borderColor: controller.selectedDenomNTT == e
                                      ? Color(0xfff7b500)
                                      : Colors.transparent,
                                  denom: e.dAmount!.round(),
                                  image: images[3],
                                  onTap: () {
                                    controller.selectedDenomNTT = e;
                                  },
                                ),
                              )
                              .toList()),
                );
              }),
              SizedBox(
                height: 24.h,
              ),
              // Obx(
              //   () => Stack(
              //     children: [
              //       ButtonImage(
              //         Get.theme.backgroundColor,
              //         height: 56.h,
              //         textColor: ColorUI.text_1,
              //         borderColor: valueTopUp.value != 0
              //             ? ColorUI.qoinSecondary
              //             : ColorUI.border,
              //         icon: Container(
              //           margin: EdgeInsets.only(left: 16),
              //           width: 33,
              //           height: 33,
              //           decoration: BoxDecoration(
              //               color: valueTopUp.value != 0
              //                   ? ColorUI.qoinSecondary
              //                   : Color(0xff969696)),
              //           child: Icon(
              //             Icons.add,
              //             color: Colors.white,
              //           ),
              //         ),
              //         text: valueTopUp.value != 0
              //             ? valueTopUp.value.formatCurrencyRp
              //             : 'Masukan nominal top up',
              //         onPressed: () {
              //           _showDialogInputAmount();
              //         },
              //       ),
              //       Obx(
              //         () {
              //           return valueTopUp.value != 0
              //               ? Container(
              //                   height: 56.h,
              //                   padding: EdgeInsets.only(right: 12.w),
              //                   child: Align(
              //                     alignment: Alignment.centerRight,
              //                     child: Container(
              //                       margin: EdgeInsets.only(left: 16),
              //                       width: 24,
              //                       height: 24,
              //                       decoration: BoxDecoration(
              //                         color: Color(0xff969696),
              //                         borderRadius:
              //                             BorderRadius.all(Radius.circular(32)),
              //                       ),
              //                       child: InkResponse(
              //                         onTap: () {
              //                           valueNominal.value = '';
              //                           valueTopUp.value = 0;
              //                         },
              //                         child: Icon(
              //                           Icons.close,
              //                           color: Colors.white,
              //                           size: 16,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 )
              //               : SizedBox();
              //         },
              //       )

              //     ],
              //   ),
              // )
            ],
          ),
        ),
        bottomSheet: GetBuilder<QoinWalletController>(builder: (controller) {
          return ButtonBottom.qoin(
            text: Localization.buttonContinue.tr,
            onPressed: controller.selectedDenomNTT != null
                ? () {
                    controller.getVaNTT(
                        onSuccess: (data) {
                          widget.bank!.vaData = controller.vaNTT!.dVaNumber;
                          widget.bank!.vaName =
                              HiveData.userData?.fullname ?? HiveData.userData?.phone;
                          widget.bank!.howToTopUpList = WalletModel.getHowTo(
                              widget.bank!.name, widget.bank!.vaData,
                              fee: controller.selectedDenomNTT!.dFee,
                              minimum: controller.denomList[0].dAmount ?? 0);
                          Get.back();
                          Get.to(VirtualAccountScreen(
                            bank: widget.bank,
                            data: data,
                          ));
                        },
                        onError: (error) {});
                  }
                : null,
          );
        }),
      ),
    );
  }

  // _showDialogInputAmount() async {
  //   await showModalBottomSheet(
  //     context: Get.context!,
  //     isDismissible: true,
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return Stack(
  //         alignment: Alignment.bottomCenter,
  //         children: [
  //           Container(
  //             height: 789.h,
  //             width: double.infinity,
  //             padding: EdgeInsets.all(16),
  //             decoration: BoxDecoration(
  //               color: Get.theme.backgroundColor,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(32),
  //                 topRight: Radius.circular(32),
  //               ),
  //               boxShadow: [BoxShadow(color: const Color(0x14111111), offset: Offset(0, 2), blurRadius: 16, spreadRadius: 0)],
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Center(
  //                   child: Container(
  //                     width: 65.h,
  //                     height: 5.h,
  //                     margin: EdgeInsets.only(top: 12.h),
  //                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2.5)), color: Color(0xffe8e8e8)),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 32.h,
  //                 ),
  //                 Text(
  //                   WalletLocalization.topUpInputNominal.tr,
  //                   style: TextUI.title2Black,
  //                 ),
  //                 Container(
  //                   height: 50,
  //                   child: Obx(
  //                     () => Align(
  //                       alignment: Alignment.bottomLeft,
  //                       child: Text(
  //                         valueNominal.value,
  //                         style: TextUI.title2Black,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Divider(
  //                   height: 2,
  //                   color: ColorUI.blue,
  //                 )
  //               ],
  //             ),
  //           ),
  //           Container(
  //             decoration: BoxDecoration(
  //               color: Get.theme.backgroundColor,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(32),
  //                 topRight: Radius.circular(32),
  //               ),
  //               boxShadow: [BoxShadow(color: const Color(0x14111111), offset: Offset(0, 2), blurRadius: 16, spreadRadius: 0)],
  //             ),
  //             child: Container(
  //               margin: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 0),
  //               width: double.infinity,
  //               height: 544.h,
  //               color: Colors.white,
  //               child: Column(
  //                 children: [
  //                   PadAmount(
  //                     onNumberPressed: (number) {
  //                       valueNominal.value += number.toString();
  //                       print(valueNominal.value);
  //                       valueTopUp.value = int.parse(valueNominal.value);
  //                       valueNominalController.value.text = valueNominal.value;
  //                     },
  //                     onTripleZero: () {
  //                       valueNominal.value += "000";
  //                       print(valueNominal.value);
  //                       valueNominalController.value.text = valueNominal.value;
  //                       // if (pin.value.length > 0) {
  //                       //   pin.value =
  //                       //       pin.value.substring(0, pin.value.length - 1);
  //                       // }
  //                     },
  //                     onDeletedPressed: () {
  //                       if (valueNominal.value.length > 0) {
  //                         valueNominal.value = valueNominal.value.substring(0, valueNominal.value.length - 1);
  //                         print(valueNominal.value);
  //                         valueNominalController.value.text = valueNominal.value;
  //                       }
  //                     },
  //                   ),
  //                   SizedBox(
  //                     height: 16.0,
  //                   ),
  //                   Obx(
  //                     () => MainButton(
  //                       text: 'Lanjut',
  //                       onPressed: valueNominal.value.length != 0
  //                           ? () {
  //                               Get.back();
  //                               valueTopUp.value = int.parse(valueNominal.value);
  //                               selected.value = 0;
  //                             }
  //                           : null,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
