import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModalProgress extends StatefulWidget {
  final Stream<bool?> loadingStatus;
  final double opacity;
  final Color color;
  final Widget? progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget? child;
  final String? text;

  ModalProgress(
      {key,
      required this.loadingStatus,
      this.opacity = 0.3,
      this.color = Colors.black,
      this.progressIndicator,
      this.offset,
      this.dismissible = false,
      required this.child,
      this.text})
      : assert(child != null),
        assert(loadingStatus != null),
        super(key: key);

  @override
  _ModalProgressState createState() => _ModalProgressState();
}

class _ModalProgressState extends State<ModalProgress> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var progressWidget = widget.progressIndicator ??
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 120,
              height: 120,
              child: Stack(
                children: <Widget>[
                  // Center(
                  //   child: Container(
                  //     width: 90,
                  //     height: 90,
                  //     child: FittedBox(
                  //         child: Image.asset(
                  //       Assets.inisaRed,
                  //     )),
                  //   ),
                  // ),
                  Center(
                      child:
                          Lottie.asset(Assets.loadingAnimation, width: 120.h)),
                ],
              ),
            ),
            SizedBox(
              height: 14.0,
            ),
            Material(
              type: MaterialType.transparency,
              child: Text(widget.text ?? Localization.loading.tr,
                  style: TextUI.title2White, textAlign: TextAlign.center),
            )
          ],
        );

    return StreamBuilder<bool>(
        stream: widget.loadingStatus as Stream<bool>,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          List<Widget> widgetList = [];
          widgetList.add(widget.child!);
          if (snapshot.hasData && snapshot.data!) {
            Widget layOutProgressIndicator;
            if (widget.offset == null)
              layOutProgressIndicator = Center(child: progressWidget);
            else {
              layOutProgressIndicator = Positioned(
                child: progressWidget,
                left: widget.offset!.dx,
                top: widget.offset!.dy,
              );
            }
            final modal = [
              new Opacity(
                child: new ModalBarrier(
                    dismissible: widget.dismissible, color: widget.color),
                opacity: widget.opacity,
              ),
              layOutProgressIndicator
            ];
            widgetList += modal;
          }
          return new Stack(
            children: widgetList,
          );
        });
  }
}
