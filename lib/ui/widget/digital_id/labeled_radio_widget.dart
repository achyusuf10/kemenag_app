import 'package:flutter/material.dart';

class LabeledRadio<T> extends StatelessWidget {
  final Widget? title;
  final EdgeInsets? contentPadding;
  final T? groupValue;
  final T value;
  final ValueChanged<T?>? onChanged;
  final bool toggleable;
  final Color? activeColor;

  const LabeledRadio({
    this.title,
    this.contentPadding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    this.toggleable = false,
    this.activeColor,
  });

  bool get checked => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged != null
          ? () {
              if (toggleable && checked) {
                onChanged!(null);
                return;
              }
              if (!checked) {
                onChanged!(value);
              }
            }
          : null,
      child: Padding(
        padding: contentPadding ?? EdgeInsets.zero,
        child: Row(
          children: [
            Radio<T>(
              groupValue: groupValue,
              value: value,
              onChanged: onChanged,
              activeColor: activeColor ?? Theme.of(context).accentColor,
            ),
            title ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}
