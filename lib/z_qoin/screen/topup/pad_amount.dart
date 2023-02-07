import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';

class PadAmount extends StatelessWidget {
  final Function(int)? onNumberPressed;
  final GestureTapCallback? onDeletedPressed;
  final GestureTapCallback? onTripleZero;

  const PadAmount(
      {key, this.onNumberPressed, this.onDeletedPressed, this.onTripleZero})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24.w,
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
        _PadButton(
          number: 0,
          onPressed: onNumberPressed!,
        ),
        Center(
          child: InkWell(
            onTap: onTripleZero,
            child: Container(
              width: 80.h,
              height: 80.h,
              decoration: BoxDecoration(
                color: ColorUI.shape,
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
              ),
              child: Center(
                child: Text(
                  "000",
                  style: TextUI.header2Black,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: InkWell(
            onTap: onDeletedPressed,
            child: Container(
              width: 80.h,
              height: 80.h,
              decoration: BoxDecoration(
                color: ColorUI.shape,
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
              ),
              child: Center(
                child: Icon(
                  Icons.backspace,
                  color: ColorUI.text_1,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PadButton extends StatelessWidget {
  final int number;
  final Function(int number) onPressed;

  const _PadButton({key, required this.number, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(number),
      child: Center(
        child: Container(
          width: 80.h,
          height: 80.h,
          decoration: BoxDecoration(
            color: ColorUI.shape,
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
          ),
          child: Center(
            child: Text(
              "$number",
              style: TextUI.header2Black,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
