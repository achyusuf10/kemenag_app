import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/thaousand_separator.dart';
import 'package:inisa_app/z_qoin/widget/message_texfield.dart';
import 'package:qoin_sdk/models/others/contact_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:qoin_sdk/models/qoin_wallets/split_bill_result.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplitBillDestination {
  String? phoneNumber;
  String? errorText;
  TextEditingController? tfController;
  bool? isCustomSplit;

  SplitBillDestination({this.phoneNumber, this.errorText, this.tfController, this.isCustomSplit});
}

class SplitBillDetailScreen extends StatefulWidget {
  final List<ContactData> selectedContact;

  const SplitBillDetailScreen(this.selectedContact);

  @override
  _SplitBillDetailScreenState createState() => _SplitBillDetailScreenState();
}

class _SplitBillDetailScreenState extends State<SplitBillDetailScreen> {
  String amountErrorText = "";
  String amount = "0";
  FocusNode amountFocusNode = FocusNode();
  List<SplitBillDestination> splitBillDestination = [];
  // var controller = qoin.Get.find<qoin.QoinController>();
  bool disableButton = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.selectedContact.forEach((element) {
      splitBillDestination.add(SplitBillDestination(
          phoneNumber: element.phone.toUpperCase(),
          errorText: '',
          tfController: TextEditingController(text: ''),
          isCustomSplit: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget.qoin(
          title: WalletLocalization.menuRequestFund.tr,
        ),
        body: ModalProgress(
          loadingStatus: false.obs.stream,
          child: ListView(
            children: [
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(WalletLocalization.requestBillNominal.tr),
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(
                            color: (amountErrorText == "") ? Colors.grey[300]! : Colors.red),
                        borderRadius: BorderRadius.circular(4.r)),
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text("Rp", style: TextUI.subtitleBlack),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  amountFocusNode.requestFocus();
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.centerStart,
                                  children: [
                                    TextField(
                                      showCursor: false,
                                      decoration: InputDecoration(border: InputBorder.none),
                                      focusNode: amountFocusNode,
                                      keyboardType: TextInputType.number,
                                      style: TextUI.subtitleBlack.copyWith(
                                        color: Colors.transparent,
                                      ),
                                      onChanged: calculateSplitBill,
                                    ),
                                    Text(
                                      amount,
                                      style: TextUI.subtitleBlack.copyWith(
                                        color: amount.length == 0 || amount == "0"
                                            ? null
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        (amountErrorText == "")
                            ? SizedBox.shrink()
                            : Text(
                                amountErrorText,
                                maxLines: 1,
                                style: TextUI.labelRed,
                              )
                      ],
                    )),
              ),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${WalletLocalization.requestSplitBillShareWith.tr} ${widget.selectedContact.length} ${WalletLocalization.requestSplitBillShareWith2.tr}"),
                    InkWell(
                      onTap: () {
                        // Get.back(result: true);
                        // controller.calculateSplitBill(
                        //     int.parse(controller.amount.value),
                        //     widget.selectedContact.length);
                        for (var i = 0; i < splitBillDestination.length; i++) {
                          splitBillDestination[i].isCustomSplit = false;
                        }
                        calculateSplitBill(qoin.QoinWalletController.to.amountToTransfer);
                      },
                      child: Text(
                        "Reset",
                        style: TextUI.subtitleRed,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              ListView.builder(
                  itemCount: widget.selectedContact.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: CircleAvatar(
                                          backgroundColor: widget.selectedContact[index].color,
                                          child: Text(
                                            widget.selectedContact[index].initial,
                                            style: TextUI.title2White,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.selectedContact[index].name.toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextUI.subtitleBlack,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          widget.selectedContact[index].phone.toUpperCase(),
                                          style: TextUI.bodyText2Grey,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            border: Border.all(
                                                color: (splitBillDestination[index].errorText == "")
                                                    ? Colors.grey[300]!
                                                    : Colors.red),
                                            borderRadius: BorderRadius.circular(4.r)),
                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Rp", style: TextUI.subtitleBlack),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Stack(
                                                      alignment: AlignmentDirectional.centerStart,
                                                      children: [
                                                        TextField(
                                                          readOnly: amount == '0' ? true : false,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter.digitsOnly,
                                                            ThousandsSeparatorInputFormatter()
                                                          ],
                                                          // Only numbers can be entered
                                                          controller: splitBillDestination[index]
                                                              .tfController,
                                                          decoration: InputDecoration(
                                                              hintText: '0',
                                                              border: InputBorder.none),
                                                          keyboardType: TextInputType.number,
                                                          style: TextUI.subtitleBlack,
                                                          // onTap: amount == '0'
                                                          //     ? null
                                                          //     : () {
                                                          //         var firstChar =
                                                          //             tfController[
                                                          //                     index]
                                                          //                 .text
                                                          //                 .characters
                                                          //                 .first;
                                                          //         if (firstChar ==
                                                          //             '0') {
                                                          //           tfController[
                                                          //                   index]
                                                          //               .text = '';
                                                          //         }
                                                          //       },
                                                          onChanged: (val) =>
                                                              customSplitBill(val, index),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              (splitBillDestination[index].errorText == "")
                                  ? SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          splitBillDestination[index].errorText ?? "-",
                                          maxLines: 1,
                                          style: TextUI.labelRed,
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 55,
                              ),
                              Expanded(child: Container(height: 1, color: const Color(0xffe8e8e8))),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                child: MessageTextField(
                  onChanged: (val) {},
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        bottomSheet: ButtonBottom.qoin(
          text: WalletLocalization.requestSend.tr,
          onPressed: !disableButton
              ? () {
                  if (disableButton) {
                    return null;
                  }
                  // final result = await Get.to(WalletPinScreen());
                  // if (result == true) {
                  List<qoin.RequestBalanceData> requestBalanceData = [];

                  splitBillDestination.forEach((element) {
                    String id;
                    if (element.phoneNumber!.startsWith("Q")) {
                      id = element.phoneNumber!.replaceAll('-', '').replaceFirst("Q", "Q-");
                    } else {
                      id = element.phoneNumber!
                          .replaceAll("+", "")
                          .replaceAll("-", "")
                          .replaceAll(" ", "");
                      if (id.startsWith("62")) {
                        id = "0" + id.substring(2);
                      }
                    }
                    if (element.tfController?.text != '') {
                      requestBalanceData.add(qoin.RequestBalanceData(
                          id: id,
                          amount: int.parse(element.tfController!.text.replaceAll('.', ''))));
                    }
                  });
                  qoin.RequestBalanceReq requestBalanceReq =
                      qoin.RequestBalanceReq(data: requestBalanceData);
                  qoin.QoinWalletController.to.requestBalance(
                      requestBalanceReq: requestBalanceReq,
                      onSuccess: () {
                        DialogUtils.showMainPopup(
                            image: Assets.icSuccessSplitBill,
                            title: WalletLocalization.requestSent.tr,
                            description:
                                '${WalletLocalization.requestSentDesc.tr} ${requestBalanceReq.data?.length} ${WalletLocalization.requestSentDesc2.tr}',
                            mainButtonText: Localization.close.tr,
                            mainButtonFunction: () {
                              qoin.Get.back();
                              qoin.Get.back();
                              qoin.Get.back();
                              // Get.to(TransactionDetailScreen());
                            });
                      },
                      onError: (e) {
                        DialogUtils.showPopUp(type: DialogType.problem, description: e);
                      });
                  //}
                }
              : null,
        ));
  }

  Widget titleSection({String? title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16),
      child: Text(
        title!,
        style: TextUI.subtitleBlack,
      ),
    );
  }

  String formatCurrency(int val) {
    return qoin.NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(val);
  }

  void calculateSplitBill(val) {
    qoin.QoinWalletController.to.amountToTransfer = val;
    print(val);
    try {
      if (int.parse(val) < 10000 && val.length > 0) {
        amountErrorText = WalletLocalization.requestMinimum.tr;
        for (var i = 0; i < splitBillDestination.length; i++) {
          splitBillDestination[i].tfController?.text = '0';
        }
      } else if (qoin.HiveData.userData?.nIKConfirmed == false && int.parse(val) > 2000000) {
        amountErrorText = WalletLocalization.requestMaxBillBasic.tr;
        for (var i = 0; i < splitBillDestination.length; i++) {
          splitBillDestination[i].tfController?.text = '0';
        }
      } else if (qoin.HiveData.userData?.nIKConfirmed == false && int.parse(val) > 10000000) {
        amountErrorText = WalletLocalization.requestMaxBillPremi.tr;
        for (var i = 0; i < splitBillDestination.length; i++) {
          splitBillDestination[i].tfController?.text = '0';
        }
      } else {
        amountErrorText = "";
        for (var i = 0; i < splitBillDestination.length; i++) {
          splitBillDestination[i].errorText = "";
        }
        disableButton = false;
        SplitBillResult splitResult = qoin.QoinWalletController.to
            .calculateSplitBill(int.parse(val), splitBillDestination.length);
        print("split result ${splitResult.splitAmount} // ${splitResult.stoppedAt}");
        for (var i = 0; i < splitBillDestination.length; i++) {
          if (splitResult.splitAmount! >= 10000) {
            splitBillDestination[i].tfController?.text =
                formatCurrency(splitResult.splitAmount!.toInt());
          } else {
            if (i < splitResult.stoppedAt!) {
              splitBillDestination[i].tfController?.text = formatCurrency(10000);
            } else if (i == splitResult.stoppedAt) {
              splitBillDestination[i].tfController?.text =
                  formatCurrency(10000 + splitResult.splitAmount!.toInt());
            } else {
              splitBillDestination[i].tfController?.text = "";
            }
          }
        }
      }
      amount = qoin.NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0)
          .format(int.parse(val));
    } catch (e) {
      print("error $e");
      amount = "0";
      qoin.QoinWalletController.to.amountToTransfer = "0";
      amountErrorText = WalletLocalization.inputPaymentInfo.tr;
      for (var i = 0; i < splitBillDestination.length; i++) {
        splitBillDestination[i].tfController?.text = '';
      }
    }
    setState(() {});
  }

  void customSplitBill(val, index) {
    splitBillDestination[index].isCustomSplit = true;
    String removeSeparator = splitBillDestination[index].tfController!.text.replaceAll('.', '');
    int splitAmount = 0;
    int countNotEmptyTf = 0;
    for (var i = 0; i < splitBillDestination.length; i++) {
      String nominal = '0';
      if (splitBillDestination[i].tfController!.text != '') {
        nominal = splitBillDestination[i].tfController!.text.replaceAll('.', '');
        countNotEmptyTf = countNotEmptyTf + 1;
        if (i != index) {
          splitAmount = splitAmount + int.parse(nominal);
        }
      }
    }
    //split to multiple user
    try {
      print("current textfield : $removeSeparator");
      if (int.parse(removeSeparator) < 10000 && removeSeparator.length > 0) {
        print("=========min 10.000");
        splitBillDestination[index].errorText = WalletLocalization.requestMinimum.tr;
        disableButton = true;
      } else if (splitAmount + int.parse(removeSeparator) > (double.parse(amount) * 1000)) {
        print("=========nominal lebih");
        splitBillDestination[index].errorText = WalletLocalization.requestMoreThanBill.tr;
        disableButton = true;
      } else {
        print("=========split");
        //=====calculate other textField while onchange=====//
        var currentAmount = 0;
        for (var i = 0; i < splitBillDestination.length; i++) {
          var removeSeparator = '0';
          if (splitBillDestination[i].tfController?.text != '') {
            removeSeparator = splitBillDestination[i].tfController!.text.replaceAll('.', '');
            if (splitBillDestination[i].isCustomSplit == true) {
              currentAmount = currentAmount + int.parse(removeSeparator);
            }
          }
        }
        var splitBillLeft = (double.parse(amount) * 1000).toInt() - currentAmount;
        var notCustomTfLength =
            splitBillDestination.where((element) => element.isCustomSplit == false).toList().length;
        SplitBillResult splitResult =
            qoin.QoinWalletController.to.calculateSplitBill(splitBillLeft, notCustomTfLength);

        for (var i = 0; i < splitBillDestination.length; i++) {
          if (splitBillDestination[i].isCustomSplit == true) {
            print("do nothing");
          } else {
            if (splitResult.splitAmount == 0.0 && splitResult.stoppedAt == null) {
              print("stop");
            } else {
              if ((splitResult.splitAmount ?? 0) >= 10000) {
                splitBillDestination[i].tfController?.text =
                    formatCurrency(splitResult.splitAmount!.toInt());
              } else {
                if (i < splitResult.stoppedAt! + 1) {
                  splitBillDestination[i].tfController?.text = formatCurrency(10000);
                } else if (i == splitResult.stoppedAt! + 1) {
                  splitBillDestination[i].tfController?.text =
                      formatCurrency(10000 + splitResult.splitAmount!.toInt());
                } else {
                  splitBillDestination[i].tfController?.text = "";
                }
              }
            }
          }
        }

        splitBillDestination[index].errorText = "";
        print("split amount ${splitResult.splitAmount}");
        try {
          if (currentAmount + (splitResult.splitAmount!.toInt() * notCustomTfLength) ==
              (double.parse(amount) * 1000)) {
            for (var i = 0; i < splitBillDestination.length; i++) {
              splitBillDestination[i].errorText = "";
            }
            disableButton = false;
          }
        } catch (e) {
          for (var i = 0; i < splitBillDestination.length; i++) {
            splitBillDestination[i].errorText = WalletLocalization.requestBillNotMatched.tr;
          }
        }
      }
    } catch (e) {
      // tfController[index].text = '0';
      print("error $e");
      // tfErrorText[index] = "Harap masukkan nominal dengan benar";
    }
    setState(() {});
  }
}
