import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/dashed_separator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'poin_detail_page.dart';

class PoinTransactionPage extends StatefulWidget {
  const PoinTransactionPage({Key? key}) : super(key: key);

  @override
  _PoinTransactionPageState createState() => _PoinTransactionPageState();
}

class _PoinTransactionPageState extends State<PoinTransactionPage> {
  RefreshController? refreshController;
  ScrollController? scrollController;

  @override
  void initState() {
    refreshController = RefreshController(initialRefresh: false);
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 30,
        itemBuilder: (_, i) {
          return InkWell(
            onTap: () {
              DialogUtils.showGeneralDrawer(
                  radius: 24.r,
                  withStrip: true,
                  content: PoinDetailPage(),
                  padding: EdgeInsets.only(top: 12));
            },
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          Assets.itemHadiah,
                          height: 40.w,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Cashback',
                                    style: TextUI.subtitleBlack,
                                  ),
                                  Text(
                                    '+12.000',
                                    style: TextUI.subtitleBlack.copyWith(color: ColorUI.succes),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '2 Agustus 2021',
                                    style: TextUI.labelGrey,
                                  ),
                                  Text(
                                    '(12 Qoin)',
                                    style: TextUI.labelGrey,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  DashedSeparator(
                    color: ColorUI.border,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
