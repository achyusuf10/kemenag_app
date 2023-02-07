import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/contact/contact_widget.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'pay_me_detail_screen.dart';

class PayMeScreen extends StatefulWidget {
  const PayMeScreen({key}) : super(key: key);

  @override
  _PayMeScreenState createState() => _PayMeScreenState();
}

class _PayMeScreenState extends State<PayMeScreen> {
  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.QoinWalletController.to.isLoadingGetVa.stream,
      child: Scaffold(
        appBar: AppBarWidget.qoin(
          title: WalletLocalization.menuRequestFund.tr,
        ),
        body: Column(
          children: [
            ContactWidget(
              onItemTap: (val) {
                String phoneNumber = val.phone.toUpperCase();
                if (phoneNumber.startsWith("Q")) {
                  phoneNumber = val.phone.toUpperCase().replaceAll('-', '').replaceFirst("Q", "Q-");
                } else {
                  phoneNumber =
                      val.phone.replaceAll("+", "").replaceAll("-", "").replaceAll(" ", "");
                  if (phoneNumber.startsWith("62")) {
                    phoneNumber = "0" + phoneNumber.substring(2);
                  }
                }
                if (phoneNumber.startsWith("0") || phoneNumber.startsWith("Q")) {
                  qoin.QoinWalletController.to.getVa(
                    phoneNumber: phoneNumber,
                    onSuccess: () {
                      qoin.Get.to(PayMeDetailScreen(
                        contactDestination: val,
                      ));
                    },
                    onError: (val) {
                      DialogUtils.showMainPopup(
                          image: Assets.icUnregistered,
                          title: WalletLocalization.notINISAUser.tr,
                          description: WalletLocalization.notINISAUserDesc.tr,
                          mainButtonText: WalletLocalization.invite.tr,
                          mainButtonFunction: () => qoin.Get.back());
                    },
                  );
                }
              },
            ),
          ],
        ),
        // bottomSheet: MainButton(
        //   text: 'Lanjut',
        //   onPressed: () async {
        //     if (selectedContact.isEmpty) {
        //       Fluttertoast.showToast(
        //           msg: "Harap pilih kontak tujuan terlebih dahulu.",
        //           toastLength: Toast.LENGTH_SHORT,
        //           gravity: ToastGravity.TOP,
        //           timeInSecForIosWeb: 1,
        //           backgroundColor: Colors.red,
        //           textColor: Colors.white,
        //           fontSize: 16.0);
        //     } else {
        //       final result = await Get.to(SplitBillDetailScreen(selectedContact));
        //       if (result) {
        //         selectedContact.clear();
        //         setState(() {});
        //       }
        //     }
        //   },
        // ),
      ),
    );
  }
}
