import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/screen/digital_id/select_id_type_screen.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationData data;
  const NotificationDetailScreen({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.light(title: 'Detail Informasi'),
      backgroundColor: ColorUI.shape,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${data.title}',
                  style: TextUI.subtitleBlack,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  '${data.body}',
                  style: TextUI.bodyTextBlack,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Kembali ke Home',
                        onPressed: () => Get.offAll(() => HomeScreen(), binding: OnloginBindings()),
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Expanded(
                      child: MainButton(text: 'Digitalisasi Ulang',
                        onPressed: () {
                          Get.offAll(HomeScreen());
                          Get.to(() => SelectIdTypeScreen());
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
