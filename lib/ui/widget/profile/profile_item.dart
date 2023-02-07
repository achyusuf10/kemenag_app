import 'package:flutter/material.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/helper/ui_text.dart';

class ProfileItem extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final TextInputType? textInputType;
  final List<RegexValidation> validation;
  final String labelText;
  final String hintText;
  final String assetImage;
  final Widget? suffixIcon;
  final Widget? statusWidget;
  final bool profileStatus;
  final int? maxLength;
  final String? initialValue;
  final Function(String)? onChange;
  final FormFieldValidator<String>? validator;
  final GestureTapCallback? onTap;

  ProfileItem(
      {this.controller,
      this.focusNode,
      this.textCapitalization = TextCapitalization.none,
      this.readOnly = false,
      this.textInputType,
      this.validation = const [],
      required this.labelText,
      required this.hintText,
      required this.assetImage,
      this.suffixIcon,
      this.statusWidget,
      this.profileStatus = false,
      this.maxLength,
      this.initialValue,
      this.onChange,
      this.validator,
      this.onTap});

  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  TextEditingController? _controller;
  var errorText = ''.obs;

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
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.assetImage,
                height: 24.0,
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.labelText, style: TextUI.bodyText2Grey2),
                        if (widget.statusWidget != null) widget.statusWidget!
                      ],
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    !widget.profileStatus
                        ? TextFormField(
                            onTap: widget.onTap,
                            controller: _controller,
                            focusNode: widget.focusNode ?? null,
                            textCapitalization: widget.textCapitalization,
                            readOnly: widget.readOnly,
                            enabled: widget.readOnly ? false : true,
                            keyboardType: widget.textInputType,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(widget.maxLength),
                            ],
                            validator: widget.validator ??
                                (String? value) {
                                  String? error;
                                  widget.validation.forEach((element) {
                                    RegExp regExp = new RegExp(element.regex);
                                    if (!regExp.hasMatch(value!)) {
                                      error = element.errorMesssage;
                                    }
                                  });
                                  return error;
                                },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: widget.onChange,
                            style: TextUI.bodyTextBlack,
                            decoration: InputDecoration.collapsed(
                              hintText: widget.hintText,
                              // counterText: "",
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: widget.onTap,
                                    child: Text(widget.initialValue!,
                                        style: TextUI.bodyTextBlack.copyWith(
                                            color: widget.labelText == Localization.handphoneNumber.tr
                                                ? Color(0xffb5b5b5)
                                                : Colors.black)),
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  if (widget.labelText != "Qointag")
                                    Image.asset(
                                      Assets.iconSuccess,
                                      height: 16.0,
                                    ),
                                ],
                              ),
                              if (widget.labelText == "Qointag" && widget.initialValue != '-')
                                InkResponse(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: widget.initialValue));
                                    Get.snackbar("Qointag", Localization.qoinTagCopied.tr,
                                        snackPosition: SnackPosition.BOTTOM,
                                        animationDuration: Duration(milliseconds: 300));
                                  },
                                  child: Image.asset(
                                    Assets.iconCopy,
                                    height: 24.0,
                                  ),
                                ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }
}
