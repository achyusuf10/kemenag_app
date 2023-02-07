import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:qoin_sdk/models/qoin_accounts/file_upload_result.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PPWidget extends StatefulWidget {
  final FileUploadResult? value;
  final Function(FileUploadResult?)? onChanged;
  final String hint;
  final bool clickable;

  const PPWidget(
      {key,
      this.value,
      this.onChanged,
      this.hint = 'Format file .jpeg, .jpg dan .png',
      this.clickable = true})
      : super(key: key);

  @override
  _PPWidgetState createState() => _PPWidgetState();
}

class _PPWidgetState extends State<PPWidget> {
  var fileName = ''.obs;

  @override
  void initState() {
    super.initState();

    if (widget.value != null) {
      fileName.value = widget.value!.fileName!;
    }
  }

  Future<FileUploadResult?> getImage({ImageSource source = ImageSource.gallery}) async {
    final ImagePicker _picker = ImagePicker();
    var xFile =
        await _picker.pickImage(source: source, maxWidth: 1080, maxHeight: 1080, imageQuality: 100);
    if (xFile != null) {
      var pickedFile = new File(xFile.path);
      debugPrint('before length: ${await pickedFile.length()} and path = ${pickedFile.path}');
      fileName.value = pickedFile.path.split('/').last;
      var img = await CompressionUtils.compressToMaxSize(pickedFile, 40000);

      pickedFile.writeAsBytesSync(img);
      debugPrint('after length: ${await pickedFile.length()} and path = ${pickedFile.path}');
      return FileUploadResult(
          fileName: fileName.value, base64Value: base64Encode(img), filePath: pickedFile.path);
    } else {
      fileName.value = '';
      debugPrint('No image selected.');
      return null;
    }
  }

  void onTap() async {
    FocusScope.of(context).requestFocus(FocusNode());
    DialogUtils.showGeneralDrawer(
        content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
          child: InkWell(
            onTap: () async {
              Get.back();
              var result = await getImage();
              widget.onChanged!(result);
            },
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                children: [
                  Icon(Icons.image),
                  Text(
                    Localization.galeri.tr,
                    style: TextUI.bodyTextBlack,
                  ),
                ],
              ),
            ),
          ),
        ),
        Card(
          child: InkWell(
            onTap: () async {
              Get.back();
              var result = await getImage(source: ImageSource.camera);
              widget.onChanged!(result);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Icon(Icons.camera_alt),
                  Text(
                    Localization.camera.tr,
                    style: TextUI.bodyTextBlack,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96.w,
      width: 96.w,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(192),
            child: GestureDetector(
              onTap: widget.clickable ? onTap : null,
              child: Container(
                height: 96.w,
                width: 96.w,
                child: widget.value == null ||
                        widget.value!.base64Value == null ||
                        HiveData.userData?.pict == null
                    ? HiveData.userData!.fullname != null && HiveData.userData!.fullname != ""
                        ? CircleAvatar(
                            radius: 48.w,
                            backgroundColor: Color(0xff3ba7c4),
                            child: Text(InitialName.parseName(HiveData.userData!.fullname!),
                                style: TextUI.titleBlack.copyWith(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)))
                        : Container(
                            color: Color(0xff3ba7c4),
                            padding: EdgeInsets.all(16.w),
                            child: Image.asset(
                              Assets.person,
                            ),
                          )
                    : Image.memory(
                        base64Decode(HiveData.userData!.pict ?? widget.value!.base64Value!),
                        fit: BoxFit.cover),
              ),
            ),
          ),
          if (widget.clickable)
            Positioned(
              right: 5,
              bottom: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 24.w,
                    width: 24.w,
                    // enableScale: true,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xffdedede),
                                offset: Offset(0, 5),
                                blurRadius: 4.r,
                                spreadRadius: 3)
                          ],
                          color: Colors.white),
                      child: Icon(
                        Icons.create,
                        size: 16.w,
                        color: ColorUI.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    // return Column(
    //   children: [
    //     ClipRRect(
    //       borderRadius: BorderRadius.circular(80),
    //       child: ResponsiveWidget(
    //         height: 80,
    //         width: 80,
    //         enableScale: true,
    //         child: widget.value == null || widget.value!.base64Value == null
    //             ? Container(
    //                 color: QoinAccount.theme.accentColor,
    //                 padding: EdgeInsets.all(23.h),
    //                 child: Image(
    //                   image: Assets.person,
    //                   fit: BoxFit.cover,
    //                 ),
    //               )
    //             : Image.memory(base64Decode(widget.value!.base64Value!),
    //                 fit: BoxFit.cover),
    //       ),
    //     ),
    //     SizedBox(height: 12),
    //     GestureDetector(
    //         onTap: onTap,
    //         child: Text("Unggah Foto Profil",
    //             style: Get.textTheme.headline6!.copyWith(
    //                 fontWeight: FontWeight.w700,
    //                 decoration: TextDecoration.underline,
    //                 color: Get.theme.accentColor)))
    //   ],
    // );
  }
}
