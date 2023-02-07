import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/contact/contact_widget.dart';
import 'package:qoin_sdk/models/others/contact_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'split_bill_detail_screen.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({key}) : super(key: key);

  @override
  _SplitBillScreenState createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  List<ContactData> selectedContact = [];
  int selectedLengthBefore = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.qoin(
        title: WalletLocalization.menuRequestFund.tr,
        actions: [
          TextButton(
              onPressed: () async {
                if (selectedContact.isEmpty) {
                  Fluttertoast.showToast(
                      msg: WalletLocalization.contactMustSelect.tr,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  final result = await qoin.Get.to(SplitBillDetailScreen(selectedContact));
                  if (result) {
                    selectedContact.clear();
                    setState(() {});
                  }
                }
              },
              child: Text(
                Localization.finish.tr,
                style: TextUI.buttonTextRed,
              ))
        ],
      ),
      body: Column(
        children: [
          ContactWidget.multi(
            maxSelected: 9,
            selectedContact: selectedContact,
            onChange: (phones) {
              // selectedContact = phones;
              if (selectedContact.length > selectedLengthBefore) {
                String phoneNumber = phones.last.phone.toUpperCase();
                if (phoneNumber.startsWith("Q")) {
                  phoneNumber =
                      phones.last.phone.toUpperCase().replaceAll('-', '').replaceFirst("Q", "Q-");
                } else {
                  phoneNumber =
                      phones.last.phone.replaceAll("+", "").replaceAll("-", "").replaceAll(" ", "");
                  if (phoneNumber.startsWith("62")) {
                    phoneNumber = "0" + phoneNumber.substring(2);
                  }
                }
                if (phoneNumber.startsWith("0") || phoneNumber.startsWith("Q")) {
                  qoin.QoinWalletController.to.getVa(
                      phoneNumber: phoneNumber.toUpperCase(),
                      onSuccess: () {
                        // qoinController.transferDestination = val;
                        // Get.to(SplitBillDetailScreen());
                        selectedContact = phones;
                        selectedLengthBefore = selectedLengthBefore + 1;
                        setState(() {});
                      },
                      onError: (val) {
                        selectedContact.last.selected = false;
                        selectedContact.removeLast();
                        DialogUtils.showMainPopup(
                            image: Assets.icUnregistered,
                            title: WalletLocalization.notINISAUser.tr,
                            description: WalletLocalization.notINISAUserDesc.tr,
                            mainButtonText: WalletLocalization.invite.tr,
                            mainButtonFunction: () => qoin.Get.back());
                        setState(() {});
                      });
                }
              } else {
                selectedLengthBefore = selectedLengthBefore - 1;
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
    );
  }
}
