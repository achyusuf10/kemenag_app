import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final Function(dynamic)? onChange;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final TextInputType? textInputType;
  final int? limitLength;
  final int? maxLines;
  final List<RegexValidation>? validation;
  final String? labelText;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? suffix;
  final int? maxLength;
  final TextInputAction? onAction;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;

  MainTextField(
      {this.controller,
      this.initialValue,
      this.onChange,
      this.focusNode,
      this.textCapitalization = TextCapitalization.none,
      this.readOnly = false,
      this.enabled = true,
      this.obscureText = false,
      this.textInputType,
      this.limitLength,
      this.maxLines = 1,
      this.validation = const [],
      this.labelText,
      this.hintText,
      this.suffixIcon,
      this.suffix,
      this.maxLength,
      this.onAction,
      this.validator,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.inputFormatters});

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    if (widget.initialValue != null) {
      if (_controller == null) {
        _controller = TextEditingController();
      }
      _controller!.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.labelText != null) Text(widget.labelText!, style: TextUI.labelBlack)
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        TextFormField(
          controller: _controller,
          onChanged: widget.onChange,
          focusNode: widget.focusNode ?? null,
          textCapitalization: widget.textCapitalization,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          keyboardType: widget.textInputType,
          inputFormatters: widget.limitLength != null
              ? [LengthLimitingTextInputFormatter(widget.limitLength)]
              : widget.inputFormatters != null
                  ? widget.inputFormatters
                  : [],
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          validator: widget.validator ??
              (String? value) {
                String? error;
                widget.validation!.forEach((element) {
                  RegExp regExp = new RegExp(element.regex);
                  if (!regExp.hasMatch(value!)) {
                    error = element.errorMesssage;
                  }
                });
                return error;
              },
          autovalidateMode: widget.autovalidateMode,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextUI.placeHolderBlack,
            counterText: "",
            suffixIcon: widget.suffixIcon,
            suffixIconConstraints: BoxConstraints(minWidth: 24.w, maxHeight: 24.w),
            suffix: widget.suffix,
            isDense: true,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 1,
              ),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: ColorUI.disabled),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red),
            ),
          ),
          style: TextUI.bodyTextBlack,
          textInputAction: widget.onAction,
        ),
      ],
    );
  }
}
