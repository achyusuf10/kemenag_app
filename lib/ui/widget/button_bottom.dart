import 'package:flutter/material.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/ui/widget/button_main.dart';

class ButtonBottom extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final DesignType designType;

  const ButtonBottom({
    Key? key,
    required this.text,
    this.onPressed,
  })  : designType = DesignType.inisa,
        super(key: key);

  const ButtonBottom.qoin({
    Key? key,
    required this.text,
    this.onPressed,
  })  : designType = DesignType.qoin,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (designType == DesignType.qoin)
      return Container(
        padding: EdgeInsets.all(16),
        decoration: UIDesign.bottomButton,
        child: MainButton.qoin(
          text: text,
          onPressed: onPressed,
        ),
      );
    return Container(
      padding: EdgeInsets.all(16),
      decoration: UIDesign.bottomButton,
      child: MainButton(
        text: text,
        onPressed: onPressed,
      ),
    );
  }
}
