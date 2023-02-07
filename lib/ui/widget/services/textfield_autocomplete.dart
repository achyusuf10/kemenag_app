import 'package:flutter/material.dart';
import 'textfield_widget.dart';

class TextfieldAutocompleteWidget extends StatelessWidget {
  final Key? autoCompleteKey;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String)? onSelected;
  final List<String> listData;
  final String title;
  final String? hintText;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final int maxLength;
  final TextInputType keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final Function(String)? onChanged;
  const TextfieldAutocompleteWidget({
    key,
    required this.autoCompleteKey,
    required this.textEditingController,
    required this.focusNode,
    this.onSelected,
    required this.listData,
    required this.title,
    this.hintText,
    this.errorText,
    this.autovalidateMode,
    this.validator,
    this.maxLength = 13,
    this.keyboardType = TextInputType.number,
    this.prefix,
    this.suffix,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      key: autoCompleteKey,
      textEditingController: textEditingController,
      focusNode: focusNode,
      onSelected: onSelected,
      fieldViewBuilder: (context, textController, fNode, builderr) {
        return TextfieldWidget(
          title: title,
          hintText: hintText,
          phoneNumberController: textController,
          maxLength: maxLength,
          keyboardType: keyboardType,
          focusNode: fNode,
          errorText: errorText,
          prefix: prefix,
          suffix: suffix,
          onChanged: onChanged,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return WidgetsBinding.instance!.window.viewInsets.bottom > 0
            ? Material(
                elevation: 4.0,
                child: Container(
                  height: 200,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              )
            : SizedBox();
      },
      optionsBuilder: (value) {
        return listData
            .where((String element) =>
                element.toLowerCase().startsWith(value.text.toLowerCase()))
            .toList();
      },
    );
  }
}
