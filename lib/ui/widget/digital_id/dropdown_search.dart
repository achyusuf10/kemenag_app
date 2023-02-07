import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';

class DropdownSearchWidget<T> extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String? hintText;
  final FutureOr<Iterable<T>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext)? noItemsFoundBuilder;
  final Widget Function(BuildContext, Object?)? errorBuilder;
  final void Function(T) onSuggestionSelected;
  final TextCapitalization? textCapitalization;
  final String? errorText;

  const DropdownSearchWidget({
    Key? key,
    required this.controller,
    this.enabled = true,
    this.hintText,
    required this.suggestionsCallback,
    required this.itemBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    required this.onSuggestionSelected,
    this.textCapitalization,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TypeAheadField<T>(
              textFieldConfiguration: TextFieldConfiguration(
                enabled: enabled,
                controller: controller,
                textCapitalization:
                    textCapitalization ?? TextCapitalization.characters,
                style: TextUI.bodyTextBlack,
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: ColorUI.shape,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xffdedede),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: errorText != null && errorText != ''
                          ? Colors.red
                          : Color(0xffdedede),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: errorText != null && errorText != ''
                          ? Colors.red
                          : Color(0xffdedede),
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.red,
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.red,
                    ),
                  ),
                  hintText: hintText ?? 'Pilih',
                  hintStyle: TextUI.placeHolderBlack,
                ),
              ),
              errorBuilder: errorBuilder,
              itemBuilder: itemBuilder,
              noItemsFoundBuilder: noItemsFoundBuilder,
              suggestionsCallback: suggestionsCallback,
              onSuggestionSelected: onSuggestionSelected,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 17, 8, 0),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorUI.text_4,
                ),
              ),
            ),
          ],
        ),
        errorText != null && errorText != ''
            ? Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  errorText ?? '',
                  style: TextUI.labelRed,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
