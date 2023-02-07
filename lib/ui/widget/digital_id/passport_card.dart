import 'dart:convert';
import 'dart:ui';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/intl_formats.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:qoin_sdk/helpers/constants/digital_doc_status.dart';
import 'package:qoin_sdk/helpers/mrz_parser/mrz_parser.dart';
import 'package:qoin_sdk/helpers/mrz_parser/mrz_result.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/intl_formats.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class PassportCard extends StatefulWidget {
  final VoidCallback? onTap;
  final DocumentUserData? data;
  final double? height;
  final double? width;
  final bool isFullscreen;

  const PassportCard(
      {Key? key,
      this.onTap,
      this.data,
      this.width = 379,
      this.height = 233.17,
      this.isFullscreen = false})
      : super(key: key);
  @override
  _PassportCardState createState() => _PassportCardState();
}

class _PassportCardState extends State<PassportCard> {
  DocumentUserData? passportData;
  String reverseName = '';
  bool idn = false;
  String nationality = "";
  String countryCode = "";

  String dob = "";
  String dateIssuer = "";
  String dateExpiry = "";
  String gender = "";

  String code = "";

  @override
  void initState() {
    super.initState();
    passportData = widget.data;

    // var parts = passportData!.docName!.split(' ');
    // for(int i = 0; i < parts.length; i++){
    //   reverseName = parts[i];
    // }
    reverseName = passportData!.docName!.split('').reversed.join('');
    if (passportData!.docNationality?.toUpperCase() == "WNI") {
      idn = true;
      nationality = "REPUBLIK INDONESIA";
      countryCode = "IDN";
    } else {
      idn = false;
      nationality = "WNA";
      countryCode = "-";
    }

    var splitDob = passportData!.docDoB!.split('-');
    String monthDob = convertMonth(splitDob[1]);
    dob = splitDob[2] + ' ' + monthDob + ' ' + splitDob[0];

    var splitIssuer = passportData!.docIssueDate!.split('-');
    String monthIssuer = convertMonth(splitIssuer[1]);
    dateIssuer = splitIssuer[2] + ' ' + monthIssuer + ' ' + splitIssuer[0];

    var splitExpiry = passportData!.docExpired!.split('-');
    String monthExpiry = convertMonth(splitExpiry[1]);
    dateExpiry = splitExpiry[2] + ' ' + monthExpiry + ' ' + splitExpiry[0];

    if (passportData!.docGender?.toLowerCase() == "male") {
      gender = "L/M";
    } else {
      gender = "P/F";
    }

    DateFormat format = DateFormat("yyyy-mm-dd");

    List<MRZResult> MRZData = [
      MRZResult(
          documentType: passportData?.docDetails?.docPassportType ?? '',
          countryCode: passportData?.docDetails?.docCountryCode ?? '',
          surnames: ((passportData?.docName?.lastName == '' ? passportData?.docName?.firstName : passportData?.docName?.lastName) ?? '').toUpperCase(),
          givenNames: (passportData?.docName?.firstName ?? '').toUpperCase(),
          documentNumber: passportData?.docNo ?? '',
          nationalityCountryCode: passportData?.docDetails?.docCountryCode ?? '',
          birthDate: format.parse((passportData?.docDoB ?? '').substring(0, 10)),
          sex: gender == "L/M" ? Sex.male : Sex.female,
          expiryDate: format.parse(passportData?.docExpired?.substring(0, 10) ?? ''),
          personalNumber: passportData?.nIK ?? '',
      )
    ];

    code = MRZParser.buildMRZCode(MRZData);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ID");

    double textHeaderSize = widget.isFullscreen ? 16.sp : 12.sp;
    double textHeader2Size = widget.isFullscreen ? 13.sp : 8.sp;
    double textPassportSize = widget.isFullscreen ? 15.sp : 10.sp;
    double textPassport2Size = widget.isFullscreen ? 13.sp : 8.sp;
    double footerTextSize = widget.isFullscreen ? 13.sp : 8.sp;
    double footerLetterSpacing = widget.isFullscreen ? 4 : 3;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: widget.width!.w,
        height: widget.height!.w,
        margin: EdgeInsets.only(bottom: 8.w),
        decoration: idn == true
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.bgPassportWNI),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.black54, blurRadius: 3.0, offset: Offset(0.0, 0.75))
                ],
              )
            : BoxDecoration(
                color: Color(0xff3283bf),
                borderRadius: BorderRadius.circular(10),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.black54, blurRadius: 6.0, offset: Offset(0.0, 0.75))
                ],
              ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                  top: getWidthRatio(10, widget.height!).w, right: 16.w, left: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          "$nationality",
                          textAlign: TextAlign.center,
                          style: TextUI.subtitleBlack.copyWith(
                              fontSize: textHeaderSize,
                              color: idn == true ? Color(0xff2c8424) : Colors.white),
                        ),
                        if (idn == true) ...[
                          Text(
                            "REPUBLIC OF INDONESIA",
                            textAlign: TextAlign.center,
                            style: TextUI.subtitleBlack.copyWith(
                                fontSize: textHeader2Size,
                                color: Color(0xff2c8424),
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                        SizedBox(
                          height: idn == true
                              ? getWidthRatio(8, widget.height!).w
                              : getWidthRatio(10, widget.height!).w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: getWidthRatio(76, widget.height!).w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    idn == true ? "PASPOR" : "PASSPORT",
                                    style: TextUI.subtitleBlack.copyWith(
                                        fontSize: textPassportSize,
                                        color: idn == true ? Color(0xff2c8424) : Colors.white),
                                  ),
                                  if (idn == true) ...[
                                    Text(
                                      "PASSPORT",
                                      style: TextUI.subtitleBlack.copyWith(
                                          fontSize: textPassport2Size,
                                          color: idn == true ? Color(0xff2c8424) : Colors.white,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                  SizedBox(
                                    height: idn == true ? 8.w : 12.w,
                                  ),
                                  passportData!.docPictPrimary!.startsWith('http')
                                      ? Image.network(
                                          passportData!.docPictPrimary!,
                                          width: getWidthRatio(76, widget.height!).w,
                                          height: getWidthRatio(83, widget.height!).w,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.memory(
                                          base64Decode(passportData!.docPictPrimary!),
                                          width: getWidthRatio(76, widget.height!).w,
                                          height: getWidthRatio(83, widget.height!).w,
                                          fit: BoxFit.cover,
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: itemData(
                                          "JENIS / TYPE",
                                          "TYPE",
                                          "P",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: itemData(
                                          "KODE NEGARA / COUNTRY CODE",
                                          "COUNTRY CODE",
                                          "$countryCode",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: itemData("NO. PASPOR / PASSPORT NO.",
                                            "PASSPORT NUMBER", "${passportData!.docNo}",
                                            end: true),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.sp,
                                  ),
                                  itemData("NAMA LENGKAP / FULL NAME", "FULL NAME",
                                      "${passportData!.docName}"),
                                  SizedBox(
                                    height: 4.w,
                                  ),
                                  itemData("KEWARGANEGARAAN / NATIONALITY", "NATIONALITY",
                                      "${passportData!.docNationality}"),
                                  SizedBox(
                                    height: 4.w,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: itemData(
                                          "TGL. LAHIR / DATE OF BIRTH",
                                          "DATE OF BIRTH",
                                          "${DateFormat('dd MMM yyy').format(DateTime.parse(passportData!.docDoB!))}",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: itemData(
                                          "KELAMIN / SEX",
                                          "SEX",
                                          "$gender",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: itemData("TEMPAT LAHIR / PLACE OF BIRTH",
                                            "PLACE OF BIRTH", "${passportData!.docPoB}",
                                            end: true),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.w,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: itemData(
                                          "TGL. PENGELUARAN / DATE OF ISSUE",
                                          "DATE OF ISSUE",
                                          "${DateFormat('dd MMM yyy').format(DateTime.parse(passportData!.docIssueDate!))}",
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: itemData(
                                              "TGL. HABIS BERLAKU / DATE OF EXPIRY",
                                              "DATE OF EXPIRY",
                                              "${DateFormat('dd MMM yyy').format(DateTime.parse(passportData!.docExpired!))}",
                                              end: true)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.w,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      itemData(
                                        "NO. REG",
                                        "REGISTRATION NUMBER",
                                        "${passportData!.docDetails!.docRegisterNo}",
                                      ),
                                      itemData("KANTOR YANG MENGELUARKAN / ISSUING OFFICE",
                                          "ISSUING OFFICE", "${passportData!.docIssuer}",
                                          end: true),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        if (idn == true) ...[
                          SizedBox(
                            height: 4.w,
                          ),
                        ] else ...[
                          SizedBox(
                            height: 6.w,
                          ),
                          Container(
                            height: 1,
                            color: idn == true ? Colors.black : Colors.white,
                            width: double.infinity,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: getWidthRatio(4, widget.height!).w),
                child: Text(
                  code,
                  style: TextUI.bodyTextBlack.copyWith(
                      fontSize: footerTextSize, color: idn == true ? Colors.black : Colors.white, letterSpacing: footerLetterSpacing),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (passportData?.status != DigitalDocStatus.active)
              Container(
                margin: EdgeInsets.only(top: 45.w, bottom: 38.w, right: 14.w, left: 14.w),
                child: Image.asset(
                  Assets.bgUnverified,
                  height: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget itemData(String label, String labelWNA, String data, {bool end = false}) {
    double titleFontSize = widget.isFullscreen ? 8.sp : 5.sp;
    double dataFontSize = widget.isFullscreen ? 13.sp : 10.sp;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          (idn == true ? label : labelWNA).toUpperCase(),
          style: TextUI.subtitleBlack.copyWith(
              fontSize: titleFontSize, color: idn == true ? Color(0xff2c8424) : Colors.white),
        ),
        Text(
          data.toUpperCase(),
          style: TextUI.bodyTextBlack
              .copyWith(fontSize: dataFontSize, color: idn == true ? Colors.black : Colors.white),
        ),
      ],
    );
  }

  double getWidthRatio(double standard, double width) {
    double defaultRatio = standard / 233.17;
    var result = width * defaultRatio;
    return result;
  }
}

class DisplayedSimData {
  final String no;
  final String text;

  DisplayedSimData(this.no, this.text);
}

