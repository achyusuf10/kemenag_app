import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:qoin_sdk/helpers/utils/compression_utils.dart';
import 'package:qoin_sdk/models/qoin_accounts/file_upload_result.dart';

class MainFileUpload extends StatefulWidget {
  final String title;
  final FileUploadResult? value;
  final Function(FileUploadResult?)? onChanged;
  final bool readOnly;
  final String hint;
  final int maxSize;

  const MainFileUpload({
    Key? key,
    required this.title,
    this.value,
    this.readOnly = false,
    this.onChanged,
    this.hint = 'Format file .jpeg, .jpg dan .png',
    this.maxSize = 256,
  }) : super(key: key);

  @override
  _MainFileUploadState createState() => _MainFileUploadState();
}

class _MainFileUploadState extends State<MainFileUpload> {
  var fileName = ''.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.value != null) {
      fileName.value = widget.value!.fileName!;
    }
  }

  Future<FileUploadResult?> getImage({ImageSource source = ImageSource.gallery}) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      fileName.value = DigitalIdLocalization.widgetFileUploadProcess.tr;

      var img =
          await CompressionUtils.compressToMaxSize(File(pickedFile.path), widget.maxSize * 1000);

      fileName.value = pickedFile.path.split('/').last;

      return FileUploadResult(fileName: fileName.value, base64Value: base64Encode(img));
    } else {
      fileName.value = '';
      debugPrint('No image selected.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: TextUI.labelBlack,
        ),
        SizedBox(height: 10.h),
        widget.readOnly
            ? SizedBox()
            : InkWell(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DialogUtils.showGeneralDrawer(
                      content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        child: InkWell(
                          onTap: () async {
                            Get.back();
                            FileUploadResult? result = await getImage();
                            widget.onChanged!(result);
                            // if (result != null) {
                            // } else {
                            //   widget.onChanged(null)
                            // }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(Icons.image),
                                Text(
                                  DigitalIdLocalization.widgetFileUploadGallery.tr,
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
                            FileUploadResult? result = await getImage(source: ImageSource.camera);
                            widget.onChanged!(result);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(Icons.camera_alt),
                                Text(
                                  DigitalIdLocalization.widgetFileUploadCamera.tr,
                                  style: TextUI.bodyTextBlack,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ));
                },
                child: DottedBorder(
                    radius: Radius.circular(4),
                    color: Color(0xffdedede),
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    dashPattern: [6, 4],
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: ColorUI.shape,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            fileName.value.length > 0
                                ? Expanded(
                                    flex: 1,
                                    child: Text(
                                      fileName.value,
                                      style: TextUI.subtitleBlack,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : Icon(
                                    Icons.photo_camera,
                                    color: Colors.grey,
                                  ),
                            SizedBox(
                              width: 5.w,
                            ),
                            if (fileName.value.length > 0) ...[
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  DigitalIdLocalization.widgetFileUploadChange.tr,
                                  style: TextUI.bodyTextBlack.copyWith(color: Color(0xfff7b500)),
                                ),
                              )
                            ] else ...[
                              Text(
                                DigitalIdLocalization.widgetFileUploadTextUpload.tr,
                                style: TextUI.bodyTextBlack,
                              ),
                            ]
                          ],
                        ),
                      ),
                    )),
              ),
      ],
    );
  }
}
