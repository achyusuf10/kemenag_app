import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepWizardWidget extends StatelessWidget {
  final String? title;
  final bool active;
  // final AssetImage? image;
  // final String? title;
  // final String? subtitle;
  // final String? expandtitle;
  // final backgroundColor;
  // final lineColor;
  // final List<Map<String, dynamic>>? list;
  // final VoidCallback? onTap;

  const StepWizardWidget({
    Key? key,
    this.title,
    this.active = false,
    // required this.image,
    // required this.title,
    // required this.subtitle,
    // this.expandtitle,
    // this.backgroundColor = const ColorUI.shape,
    // this.lineColor = const Color(0xffdedede),
    // this.list,
    // this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              "$title",
              style: TextUI.stepperActive,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
            width: double.infinity,
            height: 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: active == true ? ColorUI.secondary : Color(0xffe5e5e5)),
          )
        ],
      ),
    );
  }
}
