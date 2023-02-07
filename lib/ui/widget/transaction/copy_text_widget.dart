import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class CopyTextWidget extends StatefulWidget {
  final String? text;
  final TextStyle? textStyle;
  const CopyTextWidget({key, required this.text, this.textStyle}) : super(key: key);

  @override
  _CopyTextWidgetState createState() => _CopyTextWidgetState();
}

class _CopyTextWidgetState extends State<CopyTextWidget> {
  @override
  Widget build(BuildContext context) {
    String _text = widget.text != null ? widget.text! : '-';
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            _text,
            textAlign: TextAlign.end,
            style: widget.textStyle ??
                TextUI.subtitleBlack.copyWith(
                  letterSpacing: 0.2,
                  fontSize: ScreenUtil().setSp(14),
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: 1.0,
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(11),
        ),
        if (_text != '-')
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            onTap: () async {
              await Clipboard.setData(
                new ClipboardData(
                  text: _text,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    QoinTransactionLocalization.trxdoneCopied.tr,
                    style: TextUI.subtitleBlack.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      fontSize: ScreenUtil().setSp(14),
                      color: Colors.white,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ),
              );
            },
            child: Image.asset(
              Assets.iconCopy,
              height: ScreenUtil().setWidth(20),
              width: ScreenUtil().setWidth(20),
            ),
          )
      ],
    );
  }
}
