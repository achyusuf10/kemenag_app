import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen_old.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/z_qoin/screen/pay/contact_screen.dart';
import 'package:inisa_app/z_qoin/screen/pay/pay_screen.dart';
import 'package:inisa_app/z_qoin/widget/message_texfield.dart';
import 'package:inisa_app/z_qoin/widget/nominal_textfield.dart';
import 'package:inisa_app/z_qoin/widget/separator_widget.dart';
import 'package:inisa_app/z_qoin/widget/source_fund_widget.dart';
import 'package:inisa_app/z_qoin/widget/title_section_text.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:qoin_sdk/qoin_sdk.dart';

class TransferQoinScreen extends StatefulWidget {
  const TransferQoinScreen({key}) : super(key: key);

  @override
  _TransferQoinScreenState createState() => _TransferQoinScreenState();
}

class _TransferQoinScreenState extends State<TransferQoinScreen> {
  var nominalFilled = false.obs;
  var destinationFilled = false.obs;
  var destinationController = TextEditingController();
  String amount = "0";
  FocusNode amountFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.QoinWalletController.to.isMainLoading.stream,
      child: Scaffold(
          appBar: AppBarWidget.qoin(
            title: WalletLocalization.menuTransfer.tr,
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(() => PayScreen());
                  // DialogUtils.showComingSoonDrawer();
                },
                child: Image.asset(
                  Assets.icQRScan,
                  width: 26.w,
                  height: 26.h,
                  color: ColorUI.qoinSecondary,
                ),
              ),
              SizedBox(
                width: 16,
              )
            ],
          ),
          body: ListView(
            children: [
              TitleSectionText(title: WalletLocalization.transferSubTitle.tr),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Focus(
                          onFocusChange: (focus) {},
                          child: MainTextField(
                            controller: destinationController,
                            hintText: WalletLocalization.transferInputPhoneTag.tr,
                            labelText: WalletLocalization.transferLabelPhoneTag.tr,
                            onChange: (value) {
                              if (value is String && value.isNotEmpty) {
                                destinationFilled.value = true;
                              } else {
                                destinationFilled.value = false;
                              }
                            },
                          )),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                        onTap: () async {
                          await qoin.Get.to(ContactScreen(
                            onItemTap: (val) {
                              String phoneNumber = val.phone
                                  .replaceAll("+", "")
                                  .replaceAll("-", "")
                                  .replaceAll(" ", "");
                              if (phoneNumber.startsWith("62")) {
                                phoneNumber = "0" + phoneNumber.substring(2);
                              }
                              if (phoneNumber.startsWith("0")) {
                                destinationController.text = phoneNumber;
                                destinationFilled.value = true;
                                qoin.Get.back();
                              }
                            },
                          ));
                        },
                        child: Image.asset(
                          Assets.icContact,
                          width: 32.w,
                          height: 32.w,
                        )),
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
                  nominalFilled.value = value;
                  if (amount != null) {
                    qoin.QoinWalletController.to.amountToTransfer = amount;
                    amount = amount;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                child: MessageTextField(
                  onChanged: (val) {
                    qoin.QoinWalletController.to.noteToTransfer = val;
                  },
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
          bottomSheet: Obx(() => ButtonBottom.qoin(
                text: WalletLocalization.sendNow.tr,
                onPressed: !nominalFilled.value || !destinationFilled.value
                    ? null
                    : () async {
                        qoin.QoinWalletController.to.isMainLoading.value = true;
                        qoin.QoinWalletController.to.getVa(
                          phoneNumber: destinationController.text,
                          onSuccess: () async {
                            qoin.QoinWalletController.to.isMainLoading.value = false;
                            final result =
                                await Get.to(PinScreenOld(pinType: qoin.PinTypeEnum.confirmationTransaction));
                            if (result != null) {
                              print("check pin result : $result");
                              await qoin.QoinWalletController.to.transferAssets(
                                onSuccess: () {
                                  DialogUtils.showMainPopup(
                                    image: Assets.icSuccessTransfer,
                                    title: WalletLocalization.transferTrxSuccess.tr,
                                    description:
                                        '${WalletLocalization.menuTransfer.tr} Rp$amount ke ${qoin.QoinWalletController.to.vaData?.mFullname ?? qoin.QoinWalletController.to.vaData?.mPhoneNumber} Berhasil',
                                    mainButtonText: Localization.close.tr,
                                    mainButtonFunction: () {
                                      Get.back();
                                      Get.back();
                                      Get.back();
                                    },
                                  );
                                },
                                onError: (error) {
                                  DialogUtils.showMainPopup(
                                    image: Assets.icClose,
                                    title: WalletLocalization.paymentFailed.tr,
                                    description: error,
                                    mainButtonText: Localization.tryAgain.tr,
                                    mainButtonFunction: () {
                                      Get.back();
                                    },
                                  );
                                  // QWDialogUtils.showProblemPopUp();
                                },
                              );
                            }
                          },
                          onError: (val) {
                            qoin.QoinWalletController.to.isMainLoading.value = false;
                            DialogUtils.showMainPopup(
                                image: Assets.icUnregistered,
                                title: WalletLocalization.notINISAUser.tr,
                                description: WalletLocalization.notINISAUserDesc.tr,
                                mainButtonText: WalletLocalization.invite.tr,
                                mainButtonFunction: () => Get.back());
                          },
                        );
                      },
              ))),
    );
  }
}
