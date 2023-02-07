import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackButtonWidget extends StatelessWidget {
  double? size;
  final VoidCallback? onPressed;
  final Color? color;
  final bool forcePop;

  BackButtonWidget(
      {this.size, this.onPressed, this.color, this.forcePop = false});

  @override
  Widget build(BuildContext context) {
    return ModalRoute.of(context)!.canPop || forcePop
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: (size ?? 16).h,
              color: color != null ? color : null,
            ),
            onPressed: onPressed ?? () => Navigator.pop(context),
          )
        : SizedBox();
  }
}
