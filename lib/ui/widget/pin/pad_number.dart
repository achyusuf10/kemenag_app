import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';

class PadNumber extends StatelessWidget {
  final Function(int)? onNumberPressed;
  final GestureTapCallback? onDeletedPressed;

  const PadNumber({key, this.onNumberPressed, this.onDeletedPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 40.w,
        mainAxisSpacing: 48.h,
      ),
      children: [
        _PadButton(
          number: 1,
          onPressed: onNumberPressed!,
        ),
        _PadButton(
          number: 2,
          onPressed: onNumberPressed!,
        ),
        _PadButton(
          number: 3,
          onPressed: onNumberPressed!,
        ),
        _PadButton(
          number: 4,
          onPressed: onNumberPressed!,
        ),
        _PadButton(
          number: 5,
          onPressed: onNumberPressed!,
        ),
        _PadButton(
          number: 6,
          onPressed: onNumberPressed!,
        ),
        _PadButton(
          number: 7,
          onPressed: onNumberPressed!,
        ),
        _PadButton(
          number: 8,
          onPressed: onNumberPressed!,
        ),
        _PadButton(
          number: 9,
          onPressed: onNumberPressed!,
        ),
        SizedBox(),
        _PadButton(
          number: 0,
          onPressed: onNumberPressed!,
        ),
        Center(
          child: InkWell(
            onTap: onDeletedPressed,
            child: Container(
              width: 80.h,
              height: 80.h,
              decoration: BoxDecoration(
                color: Color(0xff0e610000),
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
              ),
              child: Center(
                child: Icon(
                  Icons.backspace,
                  color: ColorUI.secondary,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        /*InkWell(
              onTap: onDeletedPressed,
              child: Center(
                child: ResponsiveWidget(
                  height: 27,
                  child: Icon(
                    Icons.backspace,
                    color: Colors.white,
                  ),
                ),
              ),
            )*/
      ],
    );
  }

  double getHeightRatio(double standard, double value) {
    double defaultRatio = 544 / standard;
    var result = value * defaultRatio;
    return result;
  }
}

class _PadButton extends StatelessWidget {
  final int number;
  final Function(int number) onPressed;

  const _PadButton({key, required this.number, required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(number),
      child: Center(
        child: Container(
          width: 80.h,
          height: 80.h,
          decoration: BoxDecoration(
            color: Color(0xff0e610000),
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
          ),
          child: Center(
            child: Text(
              "$number",
              style: TextUI.headerWhite.copyWith(color: ColorUI.secondary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
