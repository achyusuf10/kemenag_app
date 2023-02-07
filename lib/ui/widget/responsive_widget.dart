import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveWidget extends StatelessWidget {
  final double? height;
  final double? width;
  // final String? text;
  final TextStyle? textStyle;
  final Widget child;
  final bool enableScale;

  const ResponsiveWidget({
    key,
    this.height,
    this.width,
    // this.text,
    this.textStyle,
    this.child = const SizedBox(),
    this.enableScale = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // assert((text == null && child != Si) || (text != null && child == null));

    double? _height = height?.h;
    double? _width = width?.w;
    // double? _fontSize = ((height ?? 4) - 4).h;
    if (enableScale) {
      assert(height != null && width != null);
      _height = height!.h;
      _width = (width! * (width! / height!)).h;
      print('_width: $_width');
    }

    // TextStyle? _style = _fontSize > 0
    //     ? (textStyle ?? TextStyle()).copyWith(fontSize: _fontSize)
    //     : textStyle?.toResponsive();

    Widget _child = child;
    if (child is Icon) {
      _child = FittedBox(
        child: child,
      );
    }
    return Container(
      height: /* text != null ? null : */ _height,
      width: _width,
      child: /* text != null
          ? Text(
              text!,
              style: _style,
            )
          : */
          _child,
    );
  }
}
