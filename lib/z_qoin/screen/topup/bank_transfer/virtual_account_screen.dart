import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/dashed_separator.dart';
import 'package:inisa_app/z_qoin/model/wallet_model.dart';
import 'package:qoin_sdk/models/qoin_wallets/ntt_topup_resp.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class VirtualAccountScreen extends StatefulWidget {
  final Bank? bank;
  final RespTopUpVA? data;

  const VirtualAccountScreen({key, required this.bank, this.data}) : super(key: key);

  @override
  _VirtualAccountScreenState createState() => _VirtualAccountScreenState();
}

class _VirtualAccountScreenState extends State<VirtualAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUI.shape,
      appBar: AppBarWidget.qoin(
        title: WalletLocalization.menuTopup.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        widget.bank?.logo ?? '',
                        width: 48.w,
                        height: 30.h,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        // "${widget.bank.name.replaceAll("Bank ", "")} Virtual Account",
                        "${widget.bank?.name}",
                        style: TextUI.bodyTextBlack,
                      ),
                      // Spacer(),
                      // TextButton(
                      //     onPressed: () {},
                      //     child: Text(
                      //       "Ganti",
                      //       style:
                      //           TextStyle(color: QoinWallet.theme.accentColor, fontSize: 16, decoration: TextDecoration.underline,),
                      //     ))
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DashedSeparator(
                    color: Colors.grey[300]!,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        WalletLocalization.topUpVANumber.tr,
                        style: TextUI.bodyTextGrey,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(text: widget.bank?.vaData ?? ''));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                WalletLocalization.topUpVACopied.tr,
                                textAlign: TextAlign.center,
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.black87,
                              margin: EdgeInsets.fromLTRB(98, 0, 98,
                                  (MediaQuery.of(context).size.height - (kToolbarHeight * 3))),
                            ));
                            // QWDialogUtils.showMainPopup(
                            //   image: EmoneyAssets.icSuccessTopUp,
                            //   title: 'Berhasil',
                            //   description:
                            //       'Nomor VA ${widget.bank.vaData.mVaNumber} berhasil disalin',
                            //   mainButtonText: 'Tutup',
                            //   mainButtonFunction: () {
                            //     Get.back();
                            //   },
                            // );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.bank?.vaData ?? '',
                                style: TextUI.bodyTextBlack,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Image.asset(
                                Assets.icCopy,
                                width: 24.w,
                                height: 24.h,
                                color: ColorUI.qoinSecondary,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  DashedSeparator(
                    color: Colors.grey[300]!,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        WalletLocalization.topUpVAAccountName.tr,
                        style: TextUI.bodyTextGrey,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          widget.bank?.vaName ?? "-",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextUI.bodyTextBlack,
                        ),
                      ),
                    ],
                  ),
                  if (widget.bank?.name?.toLowerCase() == "Bank NTT".toLowerCase())
                    Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        DashedSeparator(
                          color: Colors.grey[300]!,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              WalletLocalization.topUpVANominal.tr,
                              style: TextUI.bodyTextGrey,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                (widget.data?.dNominalTopUp ?? 0).formatCurrencyRp,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: TextUI.bodyTextBlack,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        DashedSeparator(
                          color: Colors.grey[300]!,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              WalletLocalization.topUpVAAdminFee.tr,
                              style: TextUI.bodyTextGrey,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                (widget.data?.dAdminFee ??
                                        ((widget.data?.dTotalAmount ?? 0) -
                                            (widget.data?.dNominalTopUp ?? 0)))
                                    .formatCurrencyRp,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: TextUI.bodyTextBlack,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        DashedSeparator(
                          color: Colors.grey[300]!,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              WalletLocalization.topUpVABillTotal.tr,
                              style: TextUI.bodyTextGrey,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                (widget.data?.dTotalAmount ?? 0).formatCurrencyRp,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: TextUI.bodyTextBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 34,
            ),
            Text(
              WalletLocalization.topUpVATopUpSteps.tr,
              style: TextUI.title2Black,
            ),
            SizedBox(
              height: 16,
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4)),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.bank?.howToTopUpList?.length ?? 0,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ExpansionPanelList(
                        elevation: 0,
                        expansionCallback: (int idx, bool isExpanded) {
                          setState(() {
                            //close other panel
                            widget.bank?.howToTopUpList?.forEach((element) {
                              if (element != widget.bank?.howToTopUpList?[index]) {
                                element.isExpanded = false;
                              }
                            });
                            //change current panel status
                            widget.bank?.howToTopUpList?[index].isExpanded =
                                !widget.bank!.howToTopUpList![index].isExpanded!;
                          });
                        },
                        children: [
                          ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Text(
                                  widget.bank?.howToTopUpList?[index].title ?? '-',
                                  style: TextUI.subtitleBlack,
                                ),
                              );
                            },
                            body: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: ListView.separated(
                                        separatorBuilder: (context, index) => SizedBox(
                                              height: 8,
                                            ),
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: widget
                                                .bank?.howToTopUpList?[index].description?.length ??
                                            0,
                                        shrinkWrap: true,
                                        itemBuilder: (context, dIndex) {
                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${dIndex + 1}. ", style: TextUI.bodyTextBlack),
                                              Expanded(
                                                child: Text(
                                                    "${widget.bank?.howToTopUpList?[index].description?[dIndex]}",
                                                    style: TextUI.bodyText2Black),
                                              )
                                            ],
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Text("${WalletLocalization.topUpVANotes.tr} : ",
                                      style: TextUI.bodyTextBlack),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(widget.bank?.howToTopUpList?[index].notes ?? '',
                                      style: TextUI.labelGrey),
                                  (widget.bank?.howToTopUpList?.length == index + 1)
                                      ? SizedBox(
                                          height: 16,
                                        )
                                      : SizedBox(
                                          height: 0,
                                        )
                                ],
                              ),
                            ),
                            isExpanded: widget.bank?.howToTopUpList?[index].isExpanded ?? false,
                          ),
                        ],
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
