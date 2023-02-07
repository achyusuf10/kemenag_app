import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';

class MoreField<T> extends StatefulWidget {
  final String? labelText;
  final Widget? hint;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final Function(T)? onChanged;
  final String? Function(dynamic)? validator;
  final Widget? icon;
  final String? errorText;
  final autovalidateMode;

  const MoreField(
      {Key? key,
      this.labelText,
      this.hint,
      required this.items,
      this.value,
      required this.onChanged,
      this.validator,
      this.icon,
      this.errorText,
      this.autovalidateMode})
      : super(key: key);

  @override
  _MoreFieldState createState() => _MoreFieldState();
}

class _MoreFieldState extends State<MoreField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: TextUI.labelBlack,
          ),
        DropdownButtonFormField(
          validator: widget.validator ?? null,
          autovalidateMode: widget.autovalidateMode ?? null,
          items: widget.items,
          isExpanded: true,
          hint: widget.hint,
          value: widget.value,
          onChanged: widget.onChanged ?? null,
          decoration: widget.errorText != null
              ? InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: ColorUI.border),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: ColorUI.border),
                  ),
                  errorText: widget.errorText)
              : InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: ColorUI.border),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: ColorUI.border),
                  ),
                ),
          icon: widget.icon == null
              ? Icon(
                  Icons.keyboard_arrow_down,
                  size: 24.w,
                )
              : widget.icon,
        )
      ],
    );
  }
}
