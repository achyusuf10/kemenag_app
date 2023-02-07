import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/logic/model/doc_model.dart';
import 'package:qoin_sdk/helpers/constants/digital_doc_status.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class KTPNationalCard extends StatelessWidget {
  final VoidCallback? onTap;
  final DocumentUserData? data;
  final double width;
  final double height;
  final bool isFullscreen;

  const KTPNationalCard({
    Key? key,
    this.onTap,
    required this.data,
    this.width = 379,
    this.height = 233.17,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double padingSize = isFullscreen ? 24.w : 20.w;
    double headerSize = isFullscreen ? 16.w : 10.w;
    double nikSize = isFullscreen ? 14.w : 8.5.w;
    double textSize = isFullscreen ? 11.w : 7.733333333333315.sp;
    double imgWidth = isFullscreen ? 85.w : 65.w;
    double imgHeight = isFullscreen ? 104.w : 84.w;
    var inputFormat = DateFormat('yyyy-MM-dd');
    var tempDob = data?.docDoB != ''
        ? inputFormat.parse(data!.docDoB!.substring(0, 10))
        : null;
    var tempExpired = data?.docExpired != ''
        ? inputFormat.parse(data!.docExpired!.substring(0, 10))
        : null;
    var outputFormat = DateFormat('dd-MM-yyyy');

    Doc doc = new Doc(
        docAddress: data?.docAddress,
        docIssuer: data?.docIssuer,
        docGender: data?.docGender);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.w,
        margin: EdgeInsets.only(bottom: 8.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.bgKTPNasional),
            fit: BoxFit.fill,
          ),
          color: Colors.white,
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
            //if (data?.status == DigitalDocStatus.active)
            Padding(
              padding: EdgeInsets.all(padingSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${doc.province.toUpperCase()}',
                      style: TextUI.subtitleBlack,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${doc.city.toUpperCase()}',
                      style: TextUI.bodyTextBlack.copyWith(
                        fontSize: headerSize,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 2),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: _KTPField(
                                    label: 'NIK',
                                    value: '${data?.nIK}',
                                    isNIK: true,
                                    nikSize: nikSize,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Flexible(
                                  child: _KTPField(
                                    label: 'Nama',
                                    value: '${data?.docName?.toUpperCase()}',
                                    textSize: textSize,
                                  ),
                                ),
                                Flexible(
                                  child: _KTPField(
                                    label: 'Tempat/Tgl Lahir',
                                    value:
                                        '${data?.docPoB != '' ? data?.docPoB!.toUpperCase() : '-'}, ${outputFormat.format(tempDob!) != '01-01-0001' ? outputFormat.format(tempDob) : '-'}',
                                    textSize: textSize,
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: FittedBox(
                                          alignment: Alignment.centerLeft,
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Jenis Kelamin',
                                            style:
                                                TextUI.bodyTextBlack.copyWith(
                                              fontStyle: FontStyle.normal,
                                              fontSize: textSize,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          ' : ',
                                          style: TextUI.bodyTextBlack.copyWith(
                                            fontStyle: FontStyle.normal,
                                            fontSize: textSize,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            FittedBox(
                                              alignment: Alignment.centerLeft,
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                doc.genderTranslate != ''
                                                    ? '${doc.genderTranslate}'
                                                    : '-',
                                                style: TextUI.bodyTextBlack
                                                    .copyWith(
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: textSize,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            Spacer(flex: 2),
                                            FittedBox(
                                              alignment: Alignment.centerLeft,
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                'Gol. Darah  : ',
                                                style: TextUI.bodyTextBlack
                                                    .copyWith(
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: textSize,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            FittedBox(
                                              alignment: Alignment.centerLeft,
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                data?.docBlood != ''
                                                    ? '${data?.docBlood?.toUpperCase()}'
                                                    : '-',
                                                style: TextUI.bodyTextBlack
                                                    .copyWith(
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: textSize,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: _KTPField(
                                    label: 'Alamat',
                                    value: doc.address != ''
                                        ? '${doc.address.toUpperCase()}'
                                        : '-',
                                    textSize: textSize,
                                  ),
                                ),
                                Flexible(
                                  child: _KTPField(
                                    label: 'RT/RW',
                                    value: data?.docDetails?.docRtRw != ''
                                        ? '${data?.docDetails?.docRtRw}'
                                        : '-',
                                    isSub: true,
                                    textSize: textSize,
                                  ),
                                ),
                                Flexible(
                                  child: _KTPField(
                                    label: 'Kel/Desa',
                                    value: data?.docDetails?.docKelDesa != ''
                                        ? '${data?.docDetails?.docKelDesa?.toUpperCase()}'
                                        : '-',
                                    isSub: true,
                                    textSize: textSize,
                                  ),
                                ),
                                Flexible(
                                  child: _KTPField(
                                    label: 'Kecamatan',
                                    value: data?.docDetails?.docKecamatan != ''
                                        ? '${data?.docDetails?.docKecamatan?.toUpperCase()}'
                                        : '-',
                                    isSub: true,
                                    textSize: textSize,
                                  ),
                                ),
                                Flexible(
                                  child: _KTPField(
                                    label: 'Agama',
                                    value: data!.docReligion == null
                                        ? '-'
                                        : data!.docReligion!.toLowerCase() ==
                                                    'other' ||
                                                data!.docReligion == ''
                                            ? '-'
                                            : data!.docReligion?.toUpperCase(),
                                    textSize: textSize,
                                  ),
                                ),
                                Flexible(
                                  child: _KTPField(
                                    label: 'Status Perkawinan',
                                    value: data?.docMarital != ''
                                        ? '${data?.docMarital?.toUpperCase()}'
                                        : '-',
                                    textSize: textSize,
                                  ),
                                ),
                                Flexible(
                                  child: _KTPField(
                                    label: 'Pekerjaan',
                                    value: data?.docProfession != ''
                                        ? '${data?.docProfession?.toUpperCase()}'
                                        : '-',
                                    textSize: textSize,
                                  ),
                                ),
                                Flexible(
                                  child: _KTPField(
                                    label: 'Kewarganegaraan',
                                    value: data?.docNationality != ''
                                        ? '${data?.docNationality?.toUpperCase()}'
                                        : '-',
                                    textSize: textSize,
                                  ),
                                ),
                                (data!.docExpired!.isNotEmpty)
                                    ? Flexible(
                                        child: _KTPField(
                                          label: 'Berlaku Hingga',
                                          value: data?.docExpired
                                                      ?.substring(0, 10) ==
                                                  '2050-12-31'
                                              ? 'SEUMUR HIDUP'
                                              : '${outputFormat.format(tempExpired!)}',
                                          textSize: textSize,
                                        ),
                                      )
                                    : Flexible(
                                        child: _KTPField(
                                          label: 'Berlaku Hingga',
                                          value: 'SEUMUR HIDUP',
                                          textSize: textSize,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        data?.docDetails?.docPictCropping != null &&
                                data?.docDetails?.docPictCropping != "No Image"
                            ? CachedNetworkImage(
                                imageUrl: data!.docDetails!.docPictCropping!,
                                width: imgWidth,
                                height: imgHeight,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Assets.defaultProfileKTP,
                                  fit: BoxFit.cover,
                                  width: imgWidth,
                                  height: imgHeight,
                                ),
                              )
                            : data?.docPictPrimary != null
                                ? CachedNetworkImage(
                                    imageUrl: data!.docPictPrimary!,
                                    width: imgWidth,
                                    height: imgHeight,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      Assets.defaultProfileKTP,
                                      fit: BoxFit.cover,
                                      width: imgWidth,
                                      height: imgHeight,
                                    ),
                                  )
                                : Image.asset(
                                    Assets.defaultProfileKTP,
                                    width: imgWidth,
                                    height: imgHeight,
                                    fit: BoxFit.fitHeight,
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (data?.status != DigitalDocStatus.active)
              Container(
                margin: EdgeInsets.only(
                    top: 45.w, bottom: 38.w, right: 14.w, left: 14.w),
                child: Image.asset(
                  Assets.bgUnverified,
                  height: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              )

            ///
            // if (data?.status == DigitalDocStatus.unverified ||
            //     data?.status == DigitalDocStatus.onRequest)
            //   Container(
            //     width: width,
            //     height: height,
            //     child: data?.docPictSecondary != null
            //         ? CachedNetworkImage(
            //             imageUrl: data!.docPictSecondary!,
            //             width: width,
            //             height: height,
            //             fit: BoxFit.cover,
            //             placeholder: (context, url) =>
            //                 Center(child: CircularProgressIndicator()),
            //             errorWidget: (context, url, error) => Image(
            //               image: AssetImage(Assets.bgKTPNasional),
            //               fit: BoxFit.cover,
            //               width: width,
            //               height: height,
            //             ),
            //           )
            //         : Image(
            //             image: AssetImage(Assets.bgKTPNasional),
            //             width: width,
            //             height: height,
            //             fit: BoxFit.fitHeight,
            //           ),
            //   ),
          ],
        ),
      ),
    );
  }
}

class _KTPField extends StatelessWidget {
  final String label;
  final String? value;
  final bool isNIK;
  final double? nikSize;
  final double? textSize;
  final bool isSub;
  const _KTPField(
      {Key? key,
      required this.label,
      required this.value,
      this.isNIK = false,
      this.nikSize,
      this.textSize,
      this.isSub = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              isSub ? "        $label" : label,
              style: TextUI.bodyTextBlack.copyWith(
                fontSize: isNIK ? nikSize : textSize,
                fontWeight: isNIK ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            " : ",
            style: TextUI.bodyTextBlack.copyWith(
              fontSize: isNIK ? nikSize : textSize,
              fontWeight: isNIK ? FontWeight.w700 : FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          flex: 2,
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value ?? '-',
              style: TextUI.bodyTextBlack.copyWith(
                fontSize: isNIK ? nikSize : textSize,
                fontWeight: isNIK ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }
}
