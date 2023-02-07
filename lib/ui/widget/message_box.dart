import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/widget/message_clipper.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

enum AlignAngel {
  topCenter,
  topLeft,
  topRight,
  bottomCenter,
  bottomRight,
  bottomLeft,
  rightCenter,
  rightTop,
  rightBottom,
  leftCenter,
  leftTop,
  leftBottom
}

class MessageBox extends StatelessWidget {
  final String? title;
  final String? description;
  final String? actionText;
  final String? skipText;
  final VoidCallback? onActionPressed;
  final VoidCallback? onSkipPressed;
  final AlignAngel? alignAngel;
  final double? width;
  final int? tutorialCount;
  final int? tutorialActiveIndex;

  const MessageBox(
      {Key? key,
      this.title,
      this.description,
      this.actionText,
      this.skipText,
      this.onActionPressed,
      this.onSkipPressed,
      this.alignAngel,
      this.width,
      this.tutorialCount,
      this.tutorialActiveIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Alignment alignment = Alignment.center;
    double? top;
    double? bottom;
    double? left;
    double? right;
    int turnBox = 2;
    double widthBox = width ?? ScreenUtil().screenWidth * 0.8;

    switch (alignAngel) {
      case AlignAngel.topCenter:
        debugPrint('${AlignAngel.topCenter.toString()}');
        top = 0;
        right = (widthBox / 2) - 15;
        turnBox = 2;
        alignment = Alignment.center;
        break;
      case AlignAngel.topRight:
        debugPrint('${AlignAngel.topRight.toString()}');
        top = 0;
        right = widthBox / 10;
        turnBox = 2;
        alignment = Alignment.topRight;
        break;
      case AlignAngel.topLeft:
        debugPrint('${AlignAngel.topLeft.toString()}');
        top = 0;
        left = widthBox / 10;
        turnBox = 2;
        alignment = Alignment.topLeft;
        break;
      case AlignAngel.bottomCenter:
        debugPrint('${AlignAngel.bottomCenter.toString()}');
        bottom = 0;
        right = (widthBox / 2) - 15;
        turnBox = 0;
        break;
      case AlignAngel.bottomRight:
        debugPrint('${AlignAngel.bottomRight.toString()}');
        bottom = 0;
        right = widthBox / 10; //16;
        turnBox = 0;
        alignment = Alignment.bottomRight;
        break;
      case AlignAngel.bottomLeft:
        debugPrint('${AlignAngel.bottomLeft.toString()}');
        bottom = 0;
        left = widthBox / 10;
        turnBox = 0;
        break;
      case AlignAngel.rightCenter:
        debugPrint('${AlignAngel.rightCenter.toString()}');
        right = 0;
        turnBox = 0;
        break;
      case AlignAngel.rightTop:
        debugPrint('${AlignAngel.rightTop.toString()}');
        top = 0;
        right = widthBox / 3;
        turnBox = 2;
        alignment = Alignment.topRight;
        // top = 20;
        // right = 0;
        // turnBox = 1;
        break;
      case AlignAngel.rightBottom:
        debugPrint('${AlignAngel.rightBottom.toString()}');
        bottom = 20;
        right = 0;
        turnBox = 1;
        break;
      case AlignAngel.leftCenter:
        debugPrint('${AlignAngel.leftCenter.toString()}');
        left = 0;
        turnBox = 1;
        break;
      case AlignAngel.leftTop:
        debugPrint('${AlignAngel.leftTop.toString()}');
        top = 0;
        left = widthBox / 3;
        turnBox = 2;
        alignment = Alignment.topLeft;
        // top = 20;
        // left = 0;
        // turnBox = 1;
        break;
      case AlignAngel.leftBottom:
        debugPrint('${AlignAngel.leftBottom.toString()}');
        bottom = 20;
        left = 0;
        turnBox = 1;
        break;
      default:
        break;
    }

    final dotted = <Widget>[];
    for (var i = 0; i < tutorialCount!; i++) {
      dotted.add(Padding(
        padding: EdgeInsets.only(right: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 12,
            width: 12,
            child: Container(
              padding: EdgeInsets.all(1),
              color: tutorialActiveIndex == i ? Colors.black : Get.theme.unselectedWidgetColor,
              child: tutorialActiveIndex == i
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Get.theme.backgroundColor,
                          width: 1,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ),
      ));
    }

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: widthBox,
        child: Stack(
          children: [
            Positioned(
              bottom: bottom,
              left: left,
              right: right,
              top: top,
              child: RotatedBox(
                quarterTurns: turnBox,
                child: ClipPath(
                  clipper: CustomTriangleClipper(),
                  child: Container(
                    color: Colors.white,
                    width: 30,
                    height: 15,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5.w, top: 5.w),
              padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 16.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: Colors.white),
              width: widthBox,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (title != null) Text(title!, style: TextUI.subtitleBlack),
                  if (description != null)
                    SizedBox(
                      height: 5,
                    ),
                  if (description != null) Text(description!, style: TextUI.bodyText2Black),
                  if (onActionPressed != null)
                    SizedBox(
                      height: 8,
                    ),
                  if (onActionPressed != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tutorialCount != null && tutorialActiveIndex != null
                            ? Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  children: dotted,
                                ),
                              )
                            : Container(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              onSkipPressed != null
                                  ? SecondaryButton(
                                      text: skipText ?? Localization.skip.tr,
                                      borderWidth: 1,
                                      mini: true,
                                      onPressed: onSkipPressed,
                                    )
                                  : Container(),
                              SizedBox(width: 5.0),
                              MainButton(
                                text: actionText ?? Localization.next.tr,
                                mini: true,
                                onPressed: onActionPressed,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
