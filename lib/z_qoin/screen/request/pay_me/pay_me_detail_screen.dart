import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/z_qoin/widget/account_item.dart';
import 'package:inisa_app/z_qoin/widget/message_texfield.dart';
import 'package:inisa_app/z_qoin/widget/nominal_textfield.dart';
import 'package:inisa_app/z_qoin/widget/separator_widget.dart';
import 'package:inisa_app/z_qoin/widget/title_section_text.dart';
import 'package:qoin_sdk/models/others/contact_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:qoin_sdk/qoin_sdk.dart';

class PayMeDetailScreen extends StatefulWidget {
  final ContactData? contactDestination;

  const PayMeDetailScreen({this.contactDestination});

  @override
  _PayMeDetailScreenState createState() => _PayMeDetailScreenState();
}

class _PayMeDetailScreenState extends State<PayMeDetailScreen> {
  var enableButton = false.obs;
  TextEditingController destinationController = TextEditingController();
  // String amount = "0";
  FocusNode amountFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.QoinWalletController.to.isMainLoading.stream,
      child: Scaffold(
          appBar: AppBarWidget.qoin(
            title: WalletLocalization.menuRequestFund.tr,
          ),
          body: ModalProgress(
            loadingStatus: false.obs.stream,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleSectionText(
                        title: WalletLocalization.menuRequestFund.tr,
                        padding: EdgeInsets.only(bottom: 8.0),
                      ),
                      AccountItem(
                        contactDestination: widget.contactDestination!,
                        fullname: qoin.QoinWalletController.to.vaData?.mFullname ?? '-',
                        trailing: InkWell(
                          child: Image(
                            image: AssetImage((widget.contactDestination!.isFav!)
                                ? Assets.icFavoriteContactFill
                                : Assets.icFavoriteContact),
                            width: 32,
                            fit: BoxFit.fitWidth,
                          ),
                          onTap: () {
                            var message = '';
                            if (widget.contactDestination!.isFav!) {
                              ContactController.to.contactRemoveFav(widget.contactDestination!);
                              message = WalletLocalization.contactDeleteFavSuccess.tr;
                              widget.contactDestination?.isFav = false;
                            } else {
                              ContactController.to.contactAddFav(widget.contactDestination!);
                              message = WalletLocalization.contactSavedFavSuccess.tr;
                              widget.contactDestination?.isFav = true;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              content: Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    Expanded(
                                      child: Text(message),
                                    ),
                                  ],
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor:
                                  (widget.contactDestination!.isFav!) ? Colors.green : Colors.grey,
                              margin: EdgeInsets.fromLTRB(16, 16, 16,
                                  (MediaQuery.of(context).size.height - (kToolbarHeight * 3))),
                            ));
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SeparatorShapeWidget(),
                NominalTextField.request(
                  padding: EdgeInsets.all(16.0),
                  onDataChanged: (value, amount) {
                    enableButton.value = value;
                    if (amount != null) {
                      qoin.QoinWalletController.to.amountToTransfer = amount;
                    }
                  },
                ),
                // titleSection(title: WalletLocalization.requestNominal.tr),
                // Padding(
                //   padding: EdgeInsets.all(16.0),
                //   child: Container(
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //           color: Colors.grey[100],
                //           border: Border.all(
                //               color: (amountErrorText == "") ? Colors.grey[300]! : Colors.red),
                //           borderRadius: BorderRadius.circular(4.r)),
                //       padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.stretch,
                //         children: [
                //           Row(
                //             children: [
                //               Text("Rp", style: TextUI.header2Black),
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
                //                         style: TextUI.header2Black.copyWith(
                //                           color: Colors.transparent,
                //                         ),
                //                         onChanged: (val) {
                //                           qoin.QoinWalletController.to.amountToTransfer = val;
                //                           try {
                //                             if (int.parse(val) < 10000 && val.length > 0) {
                //                               amountErrorText =
                //                                   WalletLocalization.requestMinimumInfo.tr;
                //                               notEnoughBalance = false;
                //                               disableButton = true;
                //                             } else if (!qoin.HiveData.userData!.nIKConfirmed! &&
                //                                 int.parse(val) > 2000000) {
                //                               amountErrorText =
                //                                   WalletLocalization.requestMaxBillBasic.tr;
                //                               notEnoughBalance = false;
                //                               disableButton = true;
                //                             } else if (qoin.HiveData.userData!.nIKConfirmed! &&
                //                                 int.parse(val) > 10000000) {
                //                               amountErrorText =
                //                                   WalletLocalization.requestMaxBillPremi.tr;
                //                               notEnoughBalance = false;
                //                               disableButton = true;
                //                             } else {
                //                               amountErrorText = "";
                //                               notEnoughBalance = false;
                //                               disableButton = false;
                //                             }
                //                             amount = qoin.NumberFormat.currency(
                //                                     locale: "id", symbol: "", decimalDigits: 0)
                //                                 .format(int.parse(val));
                //                           } catch (e) {
                //                             amount = "0";
                //                             qoin.QoinWalletController.to.amountToTransfer = "0";
                //                             amountErrorText =
                //                                 WalletLocalization.inputPaymentInfo.tr;
                //                           }
                //                           setState(() {});
                //                         },
                //                       ),
                //                       Text(
                //                         amount,
                //                         style: TextUI.header2Black.copyWith(
                //                           color: amount.length == 0 || amount == "0"
                //                               ? null
                //                               : Colors.black,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               // (notEnoughBalance)
                //               //     ? Container(
                //               //     width: 100,
                //               //     child: MainButton(
                //               //       text: 'Top Up',
                //               //       height: 40,
                //               //       onPressed: () => Get.to(TopUpScreen()),
                //               //     ))
                //               //     : SizedBox.shrink()
                //             ],
                //           ),
                //           Text(
                //             amountErrorText,
                //             maxLines: 1,
                //             style: TextUI.labelRed,
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
                    onChanged: (val) {},
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
          bottomSheet: qoin.Obx(
            () => ButtonBottom.qoin(
              text: WalletLocalization.requestNow.tr,
              onPressed: enableButton.value
                  ? () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // final result = await Get.to(WalletPinScreen());
                      // if (result == true) {
                      List<qoin.RequestBalanceData> requestBalanceData = [];
                      String id;
                      if (widget.contactDestination!.phone.startsWith("Q")) {
                        id = widget.contactDestination!.phone
                            .replaceAll('-', '')
                            .replaceFirst("Q", "Q-");
                      } else {
                        id = widget.contactDestination!.phone
                            .replaceAll("+", "")
                            .replaceAll("-", "")
                            .replaceAll(" ", "");
                        if (id.startsWith("62")) {
                          id = "0" + id.substring(2);
                        }
                      }
                      requestBalanceData.add(qoin.RequestBalanceData(
                          id: id,
                          amount: int.parse(qoin.QoinWalletController.to.amountToTransfer!)));
                      qoin.RequestBalanceReq requestBalanceReq =
                          qoin.RequestBalanceReq(data: requestBalanceData);
                      qoin.QoinWalletController.to.requestBalance(
                          requestBalanceReq: requestBalanceReq,
                          onSuccess: () {
                            DialogUtils.showMainPopup(
                                image: Assets.icSuccessSplitBill,
                                title: WalletLocalization.requestSent.tr,
                                description:
                                    '${WalletLocalization.requestSentDesc.tr} ${widget.contactDestination?.name}',
                                mainButtonText: Localization.close.tr,
                                mainButtonFunction: () {
                                  qoin.Get.offAll(HomeScreen());
                                });
                          },
                          onError: (e) {
                            DialogUtils.showPopUp(type: DialogType.problem);
                          });
                      //}
                    }
                  : null,
            ),
          )),
    );
  }

  Widget titleSection({String? title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16),
      child: Text(
        title ?? "-",
        style: TextUI.subtitleBlack,
      ),
    );
  }
}
