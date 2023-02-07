import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/regex_rule.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/z_qoin/widget/separator_widget.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'edit_ktp_screen.dart';
import 'profile_photo_widget.dart';

class FormNamecardScreen extends StatefulWidget {
  final DocumentUserData? data;
  const FormNamecardScreen({Key? key, this.data}) : super(key: key);

  @override
  _FormNamecardScreenState createState() => _FormNamecardScreenState();
}

class _FormNamecardScreenState extends State<FormNamecardScreen> {
  var _formKey = GlobalKey<FormState>();
  final RxBool loadingStatus = false.obs;
  var pic;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: loadingStatus.stream,
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: widget.data == null ? 'Tambah Kartu Nama' : 'Detail Data',
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(24.h),
                  child: Column(
                    children: [
                      widget.data != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(45.w),
                              child: widget.data?.docPictPrimary != null
                                  ? CachedNetworkImage(
                                      imageUrl: widget.data!.docPictPrimary!,
                                      width: 80.w,
                                      height: 80.w,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        Assets.defaultProfileKTP,
                                        fit: BoxFit.cover,
                                        width: 80.w,
                                        height: 80.w,
                                      ),
                                    )
                                  : Image.asset(
                                      Assets.defaultProfileKTP,
                                      width: 80.w,
                                      height: 80.w,
                                      fit: BoxFit.cover,
                                    ),
                            )
                          : ProfileFileUpload(
                              value: pic,
                              onChanged: (file) {
                                if (file != null) {
                                  pic = file;
                                  DigitalIdController.instance.image =
                                      file.base64Value!;
                                  setState(() {});
                                }
                              },
                            ),
                    ],
                  ),
                ),
                SeparatorShapeWidget(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.data == null)
                        Text('*Silahkan isi data terlebih dahulu',
                            style: TextUI.labelRed.copyWith(fontSize: 11.sp)),
                      if (widget.data == null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Text('Warna Kartu', style: TextUI.labelBlack),
                            SizedBox(height: 5),
                            GetBuilder<DigitalIdController>(
                                builder: (controller) {
                              return SizedBox(
                                height: 50.h,
                                child: Row(
                                  children: ParameterDigidConst.cardColor
                                      .map((e) => GestureDetector(
                                            onTap: () => controller.docColor =
                                                e['value']!,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: controller.docColor ==
                                                          e['value']
                                                      ? Get.theme.colorScheme
                                                          .secondary
                                                      : Colors.transparent,
                                                  width: 1.5,
                                                ),
                                              ),
                                              padding: EdgeInsets.all(2),
                                              margin: EdgeInsets.only(right: 5),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(e[
                                                                'label'] ==
                                                            'Black'
                                                        ? Assets.icNameCardBlack
                                                        : e['label'] == 'Yellow'
                                                            ? Assets
                                                                .icNameCardOrange
                                                            : Assets
                                                                .icNameCardBlue),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              );
                            }),
                          ],
                        ),
                      SizedBox(
                        height: 16,
                      ),
                      MainTextField(
                        enabled: widget.data == null ? true : false,
                        initialValue: widget.data?.docCompany ??
                            (widget.data != null ? '-' : ''),
                        onChange: (val) {
                          DigitalIdController.instance.company = val;
                        },
                        labelText: 'Nama Perusahaan',
                        hintText: 'Masukkan nama perusahaan',
                        textInputType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        validation: [RegexRule.emptyValidationRule],
                        onAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      MainTextField(
                        enabled: widget.data == null ? true : false,
                        initialValue: widget.data?.docName ??
                            (widget.data != null ? '-' : ''),
                        onChange: (val) {
                          DigitalIdController.instance.name = val;
                        },
                        labelText: 'Nama Lengkap',
                        hintText: 'Masukkan nama lengkap',
                        textInputType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        validation: [RegexRule.emptyValidationRule],
                        onAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      MainTextField(
                        enabled: widget.data == null ? true : false,
                        initialValue: widget.data?.docDepartment ??
                            (widget.data != null ? '-' : ''),
                        onChange: (val) {
                          DigitalIdController.instance.position = val;
                        },
                        labelText: 'Posisi',
                        hintText: 'Masukkan posisi',
                        textInputType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        validation: [RegexRule.emptyValidationRule],
                        onAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      MainTextField(
                        enabled: widget.data == null ? true : false,
                        initialValue: widget.data?.docDetails?.phoneNo ??
                            (widget.data != null ? '-' : ''),
                        onChange: (val) {
                          DigitalIdController.instance.phoneNo = val;
                        },
                        labelText: 'Nomor Ponsel',
                        hintText: 'Masukkan nomor ponsel',
                        textInputType: TextInputType.number,
                        textCapitalization: TextCapitalization.characters,
                        validation: [RegexRule.emptyValidationRule],
                        onAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      MainTextField(
                        enabled: widget.data == null ? true : false,
                        initialValue: widget.data?.docDetails?.officePhoneNo ??
                            (widget.data != null ? '-' : ''),
                        onChange: (val) {
                          DigitalIdController.instance.officePhoneNo = val;
                        },
                        labelText: 'Nomor Telepon Kantor',
                        hintText: 'Masukkan nomor telepon kantor',
                        textInputType: TextInputType.number,
                        textCapitalization: TextCapitalization.characters,
                        validation: [RegexRule.emptyValidationRule],
                        onAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      MainTextField(
                        enabled: widget.data == null ? true : false,
                        initialValue: widget.data?.docDetails?.officeEmail ??
                            (widget.data != null ? '-' : ''),
                        onChange: (val) {
                          DigitalIdController.instance.officeEmail = val;
                        },
                        labelText: 'Email Kantor',
                        hintText: 'Masukkan email kantor',
                        textInputType: TextInputType.text,
                        validation: [RegexRule.emptyValidationRule],
                        onAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      MainTextField(
                        enabled: widget.data == null ? true : false,
                        initialValue: widget.data?.docDetails?.officeAddress ??
                            (widget.data != null ? '-' : ''),
                        onChange: (val) {
                          DigitalIdController.instance.officeAddress = val;
                        },
                        labelText: 'Alamat Kantor',
                        hintText: 'Masukkan alamat kantor',
                        textInputType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        validation: [RegexRule.emptyValidationRule],
                        onAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      MainTextField(
                        enabled: widget.data == null ? true : false,
                        initialValue: widget.data?.docDetails?.website ??
                            (widget.data != null ? '-' : ''),
                        onChange: (val) {
                          DigitalIdController.instance.website = val;
                        },
                        labelText: 'Website',
                        hintText: 'Masukkan alamat website',
                        textInputType: TextInputType.text,
                        validation: [RegexRule.emptyValidationRule],
                        onAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 100.h,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomSheet: widget.data == null
            ? GetBuilder<DigitalIdController>(builder: (controller) {
                return ButtonBottom(
                    text: 'Tambah Kartu Nama',
                    onPressed: controller.data.color != null &&
                            (controller.data.company != null && controller.data.company != "") &&
                            (controller.data.name != null && controller.data.name != "") &&
                            (controller.data.phoneNo != null && controller.data.phoneNo != "") &&
                            (controller.data.officePhoneNo != null && controller.data.officePhoneNo != "") &&
                            (controller.data.officeEmail!= null && controller.data.officeEmail != "") &&
                            (controller.data.officeAddress != null && controller.data.officeAddress != "") &&
                            (controller.data.website != null && controller.data.website != "") &&
                            controller.data.image != null
                        ? () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (_formKey.currentState!.validate()) {
                              loadingStatus.value = true;
                              DigitalIdController.instance.registerDocument(
                                onSuccess: (data) {
                                  loadingStatus.value = false;
                                  DialogUtils.showMainPopup(
                                      image: Assets.icAddBusinessCard,
                                      title: "Kartu Nama berhasil ditambahkan",
                                      mainButtonText: 'Lihat Kartu Nama',
                                      mainButtonFunction: () {
                                        DigitalArchiveUIController.to.joinAllCard();
                                        Get.back();
                                        Get.back();
                                        Get.to(() => FormNamecardScreen(
                                              data: data,
                                            ));
                                      });
                                },
                                onFailed: (error) {
                                  loadingStatus.value = false;
                                  DialogUtils.showPopUp(
                                      type: DialogType.problem, title: error);
                                },
                              );
                            }
                          }
                        : null);
              })
            : SizedBox(),
      ),
    );
  }
}
