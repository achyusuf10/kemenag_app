import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/z_qoin/model/wallet_model.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import '../amout_screen.dart';
import 'virtual_account_screen.dart';

class SelectBankScreen extends StatefulWidget {
  const SelectBankScreen({key}) : super(key: key);

  @override
  _SelectBankScreenState createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {
  @override
  void initState() {
    super.initState();
    WalletModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.QoinWalletController.to.isLoadingGetVa.stream,
      child: Scaffold(
        backgroundColor: ColorUI.shape,
        appBar: AppBarWidget.qoin(
          title: WalletLocalization.menuTopup.tr,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(
                height: 8,
              ),
              Text(
                WalletLocalization.topUpTransferBank.tr,
                style: TextUI.subtitleBlack,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                WalletLocalization.topUpTransferBankDesc.tr,
                style: TextUI.bodyTextBlack,
              ),
              SizedBox(
                height: 24,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: WalletModel.bankList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x28000000),
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                          color: Colors.white),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          var isActive = (WalletModel.bankList?[index].isActive ?? false);
                          if (isActive && WalletModel.bankList?[index].name != 'Bank NTT') {
                            qoin.QoinWalletController.to.getVa(
                              onSuccess: () {
                                WalletModel.init();
                                qoin.Get.to(VirtualAccountScreen(
                                  bank: WalletModel.bankList?[index],
                                ));
                              },
                              onError: (error) {},
                            );
                          } else if (isActive && WalletModel.bankList?[index].name == 'Bank NTT') {
                            qoin.Get.to(AmountScreen(
                              bank: WalletModel.bankList?[index],
                            ));
                            // qoin.Wallet.to.getDenomNTT(
                            //     onSuccess: () {
                            //       qoin.Get.to(AmountScreen(
                            //         bank: WalletModel.bankList?[index],
                            //       ));
                            //     },
                            //     onError: (error) {});
                          } else {
                            DialogUtils.showComingSoonDrawer();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                WalletModel.bankList?[index].logo ?? '',
                                width: 48.w,
                                height: 30.h,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                WalletModel.bankList?[index].name ?? '',
                                style: TextUI.subtitleBlack,
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: ColorUI.text_4,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
