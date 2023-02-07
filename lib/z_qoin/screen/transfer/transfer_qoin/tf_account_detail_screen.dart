import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen_old.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/z_qoin/widget/message_texfield.dart';
import 'package:inisa_app/z_qoin/widget/nominal_textfield.dart';
import 'package:inisa_app/z_qoin/widget/separator_widget.dart';
import 'package:inisa_app/z_qoin/widget/source_fund_widget.dart';
import 'package:inisa_app/z_qoin/widget/title_section_text.dart';
import 'package:qoin_sdk/models/qoin_wallets/transfer_out_req.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class TransferBankAccountDetailScreen extends StatefulWidget {
  QoinTransferOutData transferOutData;

  TransferBankAccountDetailScreen({key, required this.transferOutData}) : super(key: key);

  @override
  _TransferBankAccountDetailScreenState createState() => _TransferBankAccountDetailScreenState();
}

class _TransferBankAccountDetailScreenState extends State<TransferBankAccountDetailScreen> {
  var nominalFilled = false.obs;
  String amount = "0";
  FocusNode amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: QoinWalletTransferBankController.to.isLoadingMain.stream,
      child: Scaffold(
        appBar: AppBarWidget.qoin(
          title: WalletLocalization.menuTransfer.tr,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            TitleSectionText(title: WalletLocalization.transferSubTitle.tr),
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                  color: Colors.grey[100]),
              child: Row(
                children: [
                  // Image(
                  //   image: EmoneyAssets.lgBni,
                  //   width: 40.w,
                  // ),
                  // SizedBox(
                  //   width: 16,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.transferOutData.bankAccountName}",
                        style: TextUI.subtitleBlack,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${widget.transferOutData.bankName} - ${widget.transferOutData.bankAccountNo}",
                        style: TextUI.bodyText2Black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SeparatorShapeWidget(),
            SourceFundWidget(),
            SeparatorShapeWidget(),
            NominalTextField.transfer(
              padding: EdgeInsets.all(16.0),
              withTopUp: true,
              onDataChanged: (value, amount) {
                print('status: $value');
                nominalFilled.value = value;
                if (amount != null) {
                  print('amount: $amount');
                  QoinWalletTransferBankController.to.amountToTransfer = amount;
                  print('amount test: ${QoinWalletController.to.amountToTransfer}');
                  amount = amount;
                }
              },
            ),
            // Padding(
            //   padding: EdgeInsets.all(16.0),
            //   child: Container(
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //           color: Colors.grey[100],
            //           border: Border.all(
            //               color: (amountErrorText == "") ? Colors.grey[300]! : Colors.red),
            //           borderRadius: BorderRadius.circular(8)),
            //       padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.stretch,
            //         children: [
            //           Row(
            //             children: [
            //               Text("Rp", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            //               Expanded(
            //                 child: InkWell(
            //                   onTap: () {
            //                     amountFocusNode.requestFocus();
            //                   },
            //                   child: Stack(
            //                     alignment: AlignmentDirectional.centerStart,
            //                     children: [
            //                       TextField(
            //                         showCursor: false,
            //                         decoration: InputDecoration(border: InputBorder.none),
            //                         focusNode: amountFocusNode,
            //                         keyboardType: TextInputType.number,
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 26,
            //                           color: Colors.transparent,
            //                         ),
            //                         onChanged: (val) {
            //                           QoinWalletTransferBankController.to.amountToTransfer = val;
            //                           try {
            //                             if (int.parse(val) < 10000 && val.length > 0) {
            //                               amountErrorText = WalletLocalization.minimalPayment.tr;
            //                               notEnoughBalance = false;
            //                               disableButton = true;
            //                             } else if (int.parse(val) >
            //                                     int.parse(QoinWalletController.to.balance
            //                                         .replaceAll(".", "")) &&
            //                                 val.length > 0) {
            //                               amountErrorText = WalletLocalization.notEnoughBalance.tr;
            //                               notEnoughBalance = true;
            //                               disableButton = true;
            //                             } else if ((HiveData.userData?.nIKConfirmed ?? false) ==
            //                                     false &&
            //                                 int.parse(val) > 2000000) {
            //                               amountErrorText =
            //                                   WalletLocalization.transferMaxBasicInfo.tr;
            //                               notEnoughBalance = false;
            //                               disableButton = true;
            //                             } else if ((HiveData.userData?.nIKConfirmed ?? false) &&
            //                                 int.parse(val) > 10000000) {
            //                               amountErrorText =
            //                                   WalletLocalization.transferMaxPremiumInfo.tr;
            //                               notEnoughBalance = false;
            //                               disableButton = true;
            //                             } else {
            //                               amountErrorText = "";
            //                               notEnoughBalance = false;
            //                               disableButton = false;
            //                             }
            //                             amount = NumberFormat.currency(
            //                                     locale: "id", symbol: "", decimalDigits: 0)
            //                                 .format(int.parse(val));
            //                           } catch (e) {
            //                             amount = "0";
            //                             QoinWalletTransferBankController.to.amountToTransfer = "0";
            //                             amountErrorText = WalletLocalization.inputPaymentInfo.tr;
            //                           }
            //                           print("amount error text: $amountErrorText");
            //                           setState(() {});
            //                         },
            //                       ),
            //                       Text(
            //                         amount,
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 25,
            //                           color:
            //                               amount.length == 0 || amount == "0" ? null : Colors.black,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               (notEnoughBalance)
            //                   ? Container(
            //                       width: 100,
            //                       child: MainButton.qoin(
            //                         text: WalletLocalization.menuTopup.tr,
            //                         onPressed: () => Get.to(TopUpScreen()),
            //                       ))
            //                   : SizedBox.shrink()
            //             ],
            //           ),
            //           Text(
            //             amountErrorText,
            //             maxLines: 1,
            //             style: TextStyle(color: Colors.red),
            //           )
            //         ],
            //       )
            //       // Text(
            //       //   "Rp. ${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(int.parse(qoinController.amount.value))}",
            //       //   style: TextStyle(
            //       //       fontWeight: FontWeight.bold, fontSize: 25),
            //       // ),
            //       ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: MessageTextField(
                onChanged: (val) {
                  QoinWalletController.to.noteToTransfer = val;
                },
              ),
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
        bottomSheet: Obx(
          () => ButtonBottom.qoin(
            text: WalletLocalization.sendNow.tr,
            onPressed: !nominalFilled.value
                ? null
                : () {
                    if (amount != '') {
                      FocusScope.of(context).requestFocus(FocusNode());
                      QoinWalletTransferBankController.to.inquiryTransferOut(
                        bankAccount: widget.transferOutData.bankAccountNo,
                        bankCode: widget.transferOutData.bankCode,
                        amount: int.parse(QoinWalletTransferBankController.to.amountToTransfer!),
                        isPrototype: QoinWalletTransferBankController.to.isPrototype,
                        isUsingMainLoading: true,
                        onSuccess: (val) {
                          widget.transferOutData = val!;
                          showConfirmTransfer(widget.transferOutData);
                        },
                        onError: (val) {
                          DialogUtils.showPopUp(type: DialogType.problem);
                        },
                      );
                    }
                  },
          ),
        ),
      ),
    );
  }

  void showConfirmTransfer(QoinTransferOutData transferData) {
    Get.dialog(AlertDialog(
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      title: Text(WalletLocalization.transferConfirmation.tr,
          style: TextUI.subtitleBlack, textAlign: TextAlign.center),
      content: Container(
        width: ScreenUtil().screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(WalletLocalization.transferSubTitle.tr, style: TextUI.subtitleBlack),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Image(
                  image: AssetImage(Assets.icBankTransfer),
                  width: 40.w,
                  height: 40.h,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${transferData.bankAccountName}".toUpperCase(),
                        maxLines: 1,
                        style: TextUI.bodyTextBlack,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${transferData.bankAccountNo}",
                        style: TextUI.bodyText2Grey,
                      )
                    ],
                  ),
                )
              ],
            ),
            Divider(
              height: 40,
            ),
            SourceFundWidget(
              contentPadding: EdgeInsets.zero,
            ),
            Divider(
              height: 40,
            ),
            Text(WalletLocalization.transferMessage.tr, style: TextUI.subtitleBlack),
            SizedBox(
              height: 8,
            ),
            Text(
              // "${_notes.text}",
              QoinWalletController.to.noteToTransfer ?? '-',
              style: TextUI.bodyTextBlack,
            ),
            Divider(
              height: 40,
            ),
            Text(WalletLocalization.transferDetail.tr, style: TextUI.subtitleBlack),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(WalletLocalization.transferNominal.tr,
                    style: const TextStyle(color: Colors.black, fontSize: 16.0)),
                Text(
                    "Rp${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(transferData.amountValue)}",
                    style: TextUI.subtitleBlack),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(WalletLocalization.transactionPayment.tr,
                    style: const TextStyle(color: Colors.black, fontSize: 16.0)),
                Text("Rp0", style: TextUI.subtitleBlack),
              ],
            ),
            Divider(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(WalletLocalization.transferTotal.tr, style: TextUI.subtitleBlack),
                Text(
                    "Rp${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(transferData.amountValue)}",
                    style: TextUI.subtitleBlack),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: WalletLocalization.transferCancelIt.tr,
                    onPressed: () => Get.back(),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: MainButton.qoin(
                  text: WalletLocalization.sendNow.tr,
                  onPressed: () async {
                    Get.back();
                    final result =
                        await Get.to(() => PinScreenOld(pinType: PinTypeEnum.confirmationTransaction));
                    if (result != null) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      QoinTransferOutReq inquiryData = QoinTransferOutReq(
                        trxType: 20,
                        type: "VA-OUT",
                        data: QoinTransferOutData(
                            virtualAccount: QoinWalletController.to.vaData?.mVaNumber ??
                                HiveData.vaBagData?.mVaNumber,
                            bankAccountNo: transferData.bankAccountNo,
                            bankCode: transferData.bankCode,
                            bankAccountName: transferData.bankAccountName,
                            amountValue: transferData.amountValue,
                            note: QoinWalletController.to.noteToTransfer),
                      );

                      // print(
                      //     "check transfer out req ${inquiryData.toJson().toString()}");
                      QoinWalletTransferBankController.to.transferOut(
                        inquiryData: inquiryData,
                        token: result,
                        isPrototype: QoinWalletTransferBankController.to.isPrototype,
                        onSuccess: () {
                          DialogUtils.showMainPopup(
                            image: Assets.icSuccessTransfer,
                            title: WalletLocalization.transferTrxSuccess.tr,
                            description:
                                '${WalletLocalization.menuTransfer.tr} Rp$amount ke ${transferData.bankAccountName} Berhasil',
                            barrierDismissible: false,
                            mainButtonText: Localization.close.tr,
                            mainButtonFunction: () {
                              Get.offAll(() => HomeScreen(), binding: OnloginBindings());
                            },
                          );
                        },
                        onError: (val) {
                          DialogUtils.showPopUp(type: DialogType.problem);
                        },
                      );
                    }
                  },
                ))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
