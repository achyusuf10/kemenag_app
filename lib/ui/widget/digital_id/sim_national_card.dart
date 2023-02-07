import 'dart:convert';
import 'dart:ui';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:qoin_sdk/helpers/constants/digital_doc_status.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class SIMNationalCard extends StatefulWidget {
  final VoidCallback? onTap;
  final DocumentUserData? data;
  final double? height;
  final double? width;
  final bool isFullscreen;

  const SIMNationalCard(
      {Key? key,
      this.onTap,
      this.data,
      this.width = 379,
      this.height = 233.17,
      this.isFullscreen = false})
      : super(key: key);
  @override
  _SIMNationalCardState createState() => _SIMNationalCardState();
}

class _SIMNationalCardState extends State<SIMNationalCard> {
  DocumentUserData? simData;

  @override
  void initState() {
    super.initState();
    simData = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ID");
    double textTypeSize = widget.isFullscreen ? 34.sp : 18.sp;
    double textSIMNoSize = widget.isFullscreen ? 16.sp : 12.sp;
    double textItemSize = widget.isFullscreen ? 14.sp : 10.sp;
    double textDateSize = widget.isFullscreen ? 12.sp : 9.sp;
    List<DisplayedSimData> displayedSimData = [
      DisplayedSimData(
        '1',
        simData?.docName ?? '-',
      ),
      DisplayedSimData(
        '2',
        "${simData?.docPoB ?? '-'}, ${simData?.docDoB == null ? '-' : DateFormat('dd-MM-yyyy', 'ID').format(DateTime.parse(simData!.docDoB!))}",
      ),
      DisplayedSimData(
        '3',
        "${simData?.docBlood ?? '-'} - ${simData?.docGender!.toUpperCase() == "MALE" ? "PRIA" : simData?.docGender!.toUpperCase() == "FEMALE" ? "WANITA" : '-'}",
      ),
      DisplayedSimData(
        '4',
        "${simData?.docAddress ?? '-'}\n${simData?.docDetails?.docResAddress2 ?? ''}",
      ),
      DisplayedSimData(
        '5',
        simData?.docProfession ?? '-',
      ),
      DisplayedSimData(
        '6',
        simData?.docIssuer ?? '-',
      ),
    ];
    return Stack(
      children: [
        InkWell(
          onTap: widget.onTap,
          child: Container(
            width: widget.width!.w,
            height: widget.height!.w,
            margin: EdgeInsets.only(bottom: 8.w),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.bgSIMNasional),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 0.75))
              ],
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      top: getWidthRatio(40, widget.height!).w,
                      right: 16.w,
                      left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Text(
                                // "${simData!.docTypeCode == qoin.CardCode.simATypeCode.toString() ? "A" : "C"}",
                                "${simData!.docTypeCode}",
                                textAlign: TextAlign.center,
                                style: TextUI.subtitleBlack
                                    .copyWith(fontSize: textTypeSize),
                              ),
                              Text(
                                "${simData!.docNo}",
                                textAlign: TextAlign.center,
                                style: TextUI.subtitleBlack.copyWith(
                                  fontSize: textSIMNoSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            simData!.docPictPrimary!.startsWith('http')
                                ? Image.network(
                                    simData!.docPictPrimary!,
                                    width: getWidthRatio(76, widget.height!).w,
                                    height: getWidthRatio(83, widget.height!).w,
                                    fit: BoxFit.cover,
                                  )
                                : Image.memory(
                                    base64Decode(simData!.docPictPrimary!),
                                    width: getWidthRatio(76, widget.height!).w,
                                    height: getWidthRatio(83, widget.height!).w,
                                    fit: BoxFit.cover,
                                  ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: displayedSimData
                                    .map(
                                      (item) => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${item.no}. ".toUpperCase(),
                                            style: TextUI.title2Black.copyWith(
                                              fontSize: textItemSize,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              item.text.toUpperCase(),
                                              maxLines: int.parse(item.no) == 4
                                                  ? 2
                                                  : 1,
                                              style:
                                                  TextUI.title2Black.copyWith(
                                                fontSize: textItemSize,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Container(
                              width: getWidthRatio(48, widget.height!).w,
                              margin: EdgeInsets.only(
                                  top: getWidthRatio(50, widget.height!).w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.saturation,
                                    ),
                                    child: simData!.docPictPrimary!
                                            .startsWith('http')
                                        ? Image.network(
                                            simData!.docPictPrimary!,
                                            width: getWidthRatio(
                                                    48, widget.height!)
                                                .w,
                                            height: getWidthRatio(
                                                    52, widget.height!)
                                                .w,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.memory(
                                            base64Decode(
                                              simData!.docPictPrimary!,
                                            ),
                                            width: getWidthRatio(
                                                    48, widget.height!)
                                                .w,
                                            height: getWidthRatio(
                                                    52, widget.height!)
                                                .w,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        simData!.docExpired == null
                                            ? '-'
                                            : simData!.docExpired == ""
                                                ? "-"
                                                : DateFormat('dd-MM-yyyy')
                                                    .format(DateTime.parse(
                                                        simData!.docExpired!))
                                                    .toUpperCase(),
                                        style: TextUI.subtitleBlack.copyWith(
                                          fontSize: textDateSize,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (simData?.status != DigitalDocStatus.active)
                  Container(
                    margin: EdgeInsets.only(
                        top: 45.w, bottom: 38.w, right: 14.w, left: 14.w),
                    child: Image.asset(
                      Assets.bgUnverified,
                      height: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  double getWidthRatio(double standard, double width) {
    double defaultRatio = standard / 233.17; //379 / 233.17;
    var result = width * defaultRatio;
    return result;
  }
}

class DisplayedSimData {
  final String no;
  final String text;

  DisplayedSimData(this.no, this.text);
}
