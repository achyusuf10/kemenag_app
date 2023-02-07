import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/dashed_separator.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class PoinDetailPage extends StatefulWidget {
  const PoinDetailPage({Key? key}) : super(key: key);

  @override
  _PoinDetailPageState createState() => _PoinDetailPageState();
}

class _PoinDetailPageState extends State<PoinDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Detail Qoin',
            style: TextUI.title2Black,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(Assets.itemCashback, height: 40.w, fit: BoxFit.fitHeight),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cashback',
                        style: TextUI.subtitleBlack,
                      ),
                      Text(
                        'Ditambahkan ke QoinPoint',
                        style: TextUI.labelBlack,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        DashedSeparator(
          color: ColorUI.border,
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nominal Qoin',
                    style: TextUI.bodyTextGrey,
                  ),
                  Text(
                    '+1 Qoin',
                    style: TextUI.subtitleBlack.copyWith(color: ColorUI.succes),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dalam Rupiah',
                    style: TextUI.bodyTextGrey,
                  ),
                  Text(
                    100.formatCurrencyRp,
                    style: TextUI.subtitleBlack.copyWith(color: ColorUI.succes),
                  ),
                ],
              ),
            ],
          ),
        ),
        DashedSeparator(
          color: ColorUI.border,
        ),
        SizedBox(
          height: 12,
        ),
        _detailContent('Phone Number',
            'Cashback Promo Jam Tangan Type A898 [Transaction ID : 18746856] [Order ID : 98579867456]'),
        _detailContent('Nomor Invoice', 'Qoin/202039/PPL/1204856'),
        _detailContent('Cashback Dari', 'Transaksi E-Commerce'),
        _detailContent('Tanggal Transaksi', '25 September 2021, 14:20'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MainButton.qoin(
            text: 'Tutup',
            onPressed: () => Get.back(),
          ),
        )
      ],
    );
  }

  _detailContent(String title, String content) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextUI.bodyTextGrey,
          ),
          SizedBox(
            height: 8.w,
          ),
          Text(
            content,
            style: TextUI.bodyTextBlack,
          ),
        ],
      ),
    );
  }
}
