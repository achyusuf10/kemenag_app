import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as SU;
import 'package:inisa_app/helper/ui_text.dart';

class TicketItemWidget extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Widget? child;
  final String? desc;
  final TextStyle? descStyle;

  TicketItemWidget({
    key,
    required this.title,
    this.titleStyle,
    this.desc,
    this.descStyle,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: Text(
            title != null ? "$title" : '-',
            textAlign: TextAlign.start,
            maxLines: 1,
            style: titleStyle ??
                TextUI.bodyText2Black.copyWith(
                  letterSpacing: 0.2,
                ),
            textScaleFactor: 1.0,
          ),
        ),
        SizedBox(
          width: SU.ScreenUtil().setWidth(16),
        ),
        Expanded(
          child: SizedBox(
            width: SU.ScreenUtil().setWidth(158),
            child: child ??
                Text(
                  desc != null ? "$desc" : '-',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  maxLines: 3,
                  style: descStyle ??
                      TextUI.subtitleBlack.copyWith(
                        letterSpacing: 0.2,
                        fontSize: 14.sp,
                      ),
                  textScaleFactor: 1.0,
                ),
          ),
        ),
      ],
    );
  }
}
