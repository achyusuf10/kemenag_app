import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/ui_text.dart';

class TextfieldWidget extends StatelessWidget {
  final Key? keyTf;
  final String? title;
  final TextEditingController? phoneNumberController;
  final FocusNode? focusNode;
  final bool? isEnabled;
  final Widget? prefix;
  final Widget? suffix;
  final Function(String)? onChanged;
  final String? hintText;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType? keyboardType;
  const TextfieldWidget({
    key,
    this.keyTf,
    this.title,
    this.phoneNumberController,
    this.focusNode,
    this.isEnabled = true,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.hintText,
    this.errorText,
    this.autovalidateMode,
    this.validator,
    this.maxLength = 13,
    this.keyboardType = TextInputType.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextUI.labelBlack,
          ),
        if (title != null)
          SizedBox(
            height: 4,
          ),
        TextFormField(
          key: keyTf,
          enabled: isEnabled,
          style: TextUI.bodyTextBlack,
          controller: phoneNumberController,
          focusNode: focusNode,
          keyboardType: keyboardType,
          onChanged: onChanged,
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
          ],
          decoration: InputDecoration(
            border: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0xffdedede), width: 1)),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0xffdedede), width: 1)),
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0xffdedede), width: 1)),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.red)),
            errorStyle: TextUI.labelRed,
            hintStyle: TextUI.placeHolderBlack,
            // fillColor: Colors.white,
            // filled: true,
            isDense: true,
            prefixIcon: prefix,
            suffixIcon: suffix,
            hintText: hintText,
            errorText: errorText,
          ),
          autovalidateMode: autovalidateMode,
          validator: validator,
        ),
      ],
    );
  }
}
