import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';

class SearchTextField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final Color focusBorderColor;

  const SearchTextField({Key? key, required this.hint, this.onChanged})
      : focusBorderColor = ColorUI.border,
        super(key: key);

  const SearchTextField.qoin({Key? key, required this.hint, this.onChanged})
      : focusBorderColor = ColorUI.qoinSecondary,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextUI.bodyTextBlack,
      decoration: UIDesign.searchBoxStyle(hint, focusBorderColor),
      onChanged: onChanged,
    );
  }
}
