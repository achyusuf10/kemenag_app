import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/models/qoin_accounts/file_upload_result.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileFileUpload extends StatefulWidget {
  final FileUploadResult? value;
  final Function(FileUploadResult?)? onChanged;
  final String hint;
  final int maxSize;

  const ProfileFileUpload({
    key,
    this.value,
    this.onChanged,
    this.hint = 'Format file .jpeg, .jpg dan .png',
    this.maxSize = 256,
  }) : super(key: key);

  @override
  _ProfileFileUploadState createState() => _ProfileFileUploadState();
}

class _ProfileFileUploadState extends State<ProfileFileUpload> {
  var fileName = ''.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.value != null) {
      fileName.value = widget.value!.fileName!;
    }
  }

  Future<FileUploadResult?> getImage(
      {ImageSource source = ImageSource.gallery}) async {
    try {
      var xFile = await _picker.pickImage(
          source: source, maxWidth: 1080, maxHeight: 1080, imageQuality: 100);
      if (xFile != null) {
        var pickedFile = new File(xFile.path);
        fileName.value = 'Processing image...';
        debugPrint(
            'before length: ${await pickedFile.length()} and path = ${pickedFile.path}');
        fileName.value = pickedFile.path.split('/').last;
        var img = await CompressionUtils.compressToMaxSize(pickedFile, 40000);

        pickedFile.writeAsBytesSync(img);
        debugPrint(
            'after length: ${await pickedFile.length()} and path = ${pickedFile.path}');
        return FileUploadResult(
            fileName: fileName.value,
            base64Value: base64Encode(img),
            filePath: pickedFile.path);
      } else {
        fileName.value = '';
        debugPrint('No image selected.');
        return null;
      }
    } catch (e) {
      debugPrint('ERROR PILIH GAMBAR $e');
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
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Icon(Icons.image),
                  Text(
                    "Galeri",
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
                    "Kamera",
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
      height: 80.h,
      width: 80.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(192.h),
            child: GestureDetector(
              onTap: onTap,
              child: Obx(() => Container(
                    height: 80.h,
                    width: 80.h,
                    child: fileName.value.length > 0
                        ? widget.value?.base64Value != null
                            ? Image.memory(
                                base64Decode(widget.value!.base64Value!),
                                fit: BoxFit.cover)
                            : CircularProgressIndicator()
                        : Container(
                            color: Color(0xff3ba7c4),
                            padding: EdgeInsets.all(23.h),
                            child: Image.asset(
                              Assets.person,
                              fit: BoxFit.cover,
                            ),
                          ),
                  )),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 24.h,
                  width: 24.h,
                  child: Container(
                    color: Colors.grey,
                    child: Icon(
                      Icons.create,
                      size: 16.h,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
