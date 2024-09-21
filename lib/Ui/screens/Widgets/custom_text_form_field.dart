import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/Extensions/extensions.dart';
import '../../../utils/validator.dart';

enum CustomTextFieldValidator {
  nullCheck,
  phoneNumber,
  email,
  password,
  maxFifty,
  otpSix,
  minAndMixLen,
  url,
  slug,
  adTitle
}

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final int? minLine;
  final int? maxLine;
  final bool? isReadOnly;
  final List<TextInputFormatter>? formaters;
  final CustomTextFieldValidator? validator;
  final Color? fillColor;
  final Function(String value)? onChange;
  final Widget? prefix;
  final Widget? prefixWithBorder;
  final Widget? suffixWithBorder;
  final TextInputAction? action;
  final TextInputType? keyboard;
  final Widget? suffix;
  final bool? dense;
  final bool? enabled;
  final Color? borderColor;
  final Widget? fixedPrefix;
  final bool? obscureText;
  final bool autofocus;
  final int? maxLength;
  final int? minLength;
  final double? borderRadius;
  final TextStyle? hintTextStyle;
  final TextCapitalization? capitalization;
  final void Function()? onEditingComplete;
  final String? Function(String?)? customValidatorFn;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.initialValue,
    this.controller,
    this.minLine,
    this.maxLine,
    this.formaters,
    this.isReadOnly,
    this.validator,
    this.prefixWithBorder,
    this.suffixWithBorder,
    this.fillColor,
    this.onChange,
    this.prefix,
    this.keyboard,
    this.action,
    this.suffix,
    this.dense,
    this.enabled,
    this.borderColor,
    this.fixedPrefix,
    this.obscureText,
    this.autofocus = false,
    this.maxLength,
    this.hintTextStyle,
    this.minLength,
    this.borderRadius,
    this.capitalization,
    this.onEditingComplete,
    this.customValidatorFn,
    this.contentPadding,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final FocusNode focusNode = FocusNode();
  bool isFocused = false;

  late final bool iconWithBorder;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(changeFocus);
    iconWithBorder =
        widget.prefixWithBorder != null || widget.suffixWithBorder != null;
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(changeFocus);
    focusNode.dispose();
  }

  void changeFocus() => {isFocused = focusNode.hasFocus, setState(() {})};

  @override
  Widget build(BuildContext context) {
    return CustomValidator<String?>(
        initialValue: widget.controller?.text ?? widget.initialValue,
        validator: iconWithBorder ? validatorFn : (_) => null,
        builder: (state) {
          final Color borderColor;
          if (iconWithBorder) {
            borderColor = state.hasError
                ? context.color.error
                : isFocused
                    ? context.color.territoryColor
                    : widget.borderColor ??
                        context.color.borderColor.darken(50);
          } else {
            borderColor = isFocused
                ? context.color.territoryColor
                : widget.borderColor ?? context.color.borderColor.darken(50);
          }
          return Column(
            children: [
              Container(
                clipBehavior: iconWithBorder ? Clip.hardEdge : Clip.none,
                decoration: iconWithBorder
                    ? BoxDecoration(
                        color: widget.fillColor ?? context.color.secondaryColor,
                        border: Border.all(width: 1.5, color: borderColor),
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius ?? 5),
                      )
                    : null,
                child: Row(
                  children: [
                    if (widget.prefixWithBorder != null)
                      prefSufWithBorder(borderColor, widget.prefixWithBorder!),
                    Expanded(
                      child: Container(
                        decoration: iconWithBorder
                            ? BoxDecoration(
                                borderRadius: widget.prefixWithBorder != null
                                    ? BorderRadiusDirectional.horizontal(
                                        end: Radius.circular(
                                            widget.borderRadius ?? 5),
                                      )
                                    : BorderRadiusDirectional.horizontal(
                                        start: Radius.circular(
                                            widget.borderRadius ?? 5),
                                      ),
                                border: widget.prefixWithBorder != null
                                    ? BorderDirectional(
                                        start: BorderSide(
                                            width: 1.5, color: borderColor),
                                      )
                                    : BorderDirectional(
                                        end: BorderSide(
                                            width: 1.5, color: borderColor),
                                      ),
                              )
                            : null,
                        child: TextFormField(
                          autofocus: widget.autofocus,
                          focusNode: focusNode,
                          initialValue: widget.initialValue,
                          onEditingComplete: widget.onEditingComplete,
                          controller: widget.controller,
                          inputFormatters: widget.formaters,
                          obscureText: widget.obscureText ?? false,
                          textInputAction: widget.action,
                          enabled: widget.enabled,
                          keyboardAppearance: Brightness.light,
                          textCapitalization:
                              widget.capitalization ?? TextCapitalization.none,
                          readOnly: widget.isReadOnly ?? false,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: context.font.large,
                              color: context.color.textDefaultColor),
                          minLines: widget.minLine ?? 1,
                          maxLines: widget.maxLine ?? 1,
                          onChanged: (val) {
                            state.didChange(val);
                            if (widget.onChange != null) widget.onChange!(val);
                          },
                          validator: iconWithBorder ? null : validatorFn,
                          keyboardType: widget.keyboard,
                          maxLength: widget.maxLength,
                          decoration: InputDecoration(
                            contentPadding: widget.contentPadding,
                            prefix: widget.prefix,
                            isDense: widget.dense,
                            prefixIcon: widget.fixedPrefix,
                            suffixIcon: widget.suffix,
                            hintText: widget.hintText,
                            hintStyle: widget.hintTextStyle ??
                                TextStyle(
                                    color: context.color.textColorDark
                                        .withOpacity(0.7),
                                    fontSize: context.font.large),
                            filled: true,
                            fillColor: widget.fillColor ??
                                context.color.secondaryColor,
                            /*contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 14),*/
                            focusedBorder: iconWithBorder
                                ? _noBorder()
                                : OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: context.color.territoryColor),
                                    borderRadius: BorderRadius.circular(
                                        widget.borderRadius ?? 5)),
                            enabledBorder: iconWithBorder
                                ? _noBorder()
                                : OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: widget.borderColor ??
                                            context.color.borderColor
                                                .darken(50)),
                                    borderRadius: BorderRadius.circular(
                                        widget.borderRadius ?? 5)),
                            border: iconWithBorder
                                ? _noBorder()
                                : OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: widget.borderColor ??
                                            context.color.borderColor),
                                    borderRadius: BorderRadius.circular(
                                        widget.borderRadius ?? 5)),
                          ),
                        ),
                      ),
                    ),
                    if (widget.suffixWithBorder != null)
                      prefSufWithBorder(borderColor, widget.suffixWithBorder!),
                  ],
                ),
              ),
              Visibility(
                visible: state.hasError && iconWithBorder,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsetsDirectional.only(start: 14.0),
                  child: Text(
                    state.errorText ?? '',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: context.font.small,
                      color: context.color.error,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  OutlineInputBorder _noBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
      borderSide: BorderSide.none,
    );
  }

  ColorFiltered prefSufWithBorder(Color borderColor, Widget icon) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(borderColor.darken(30), BlendMode.srcIn),
      child: Container(
        width: 40,
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }

  String? validatorFn(String? value) {
    if (widget.validator == CustomTextFieldValidator.nullCheck) {
      return Validator.nullCheckValidator(value, context: context);
    }

    if (widget.validator == CustomTextFieldValidator.maxFifty) {
      if ((value ??= "").length > 50) {
        return "youCanEnter50LettersMax".translate(context);
      } else {
        return null;
      }
    }

    /* if (validator == CustomTextFieldValidator.minAndMixLen) {
                        if ((value == "") ||
                            (value!.length > maxLength!) ||
                            (value.length < minLength!)) {
                          return "${"youCanAddMinimum".translate(context)} \t $minLength \t ${"toMaximum".translate(context)} \t ${maxLength!} \t ${"numbersOnly".translate(context)}";
                        } else if (maxLength != null) {
                        } else {
                          return null;
                        }
                      }*/

    // Check if maxLength is not null and value length exceeds maxLength
    if (widget.validator == CustomTextFieldValidator.minAndMixLen) {
      // Check if the value is empty
      if (value == "") {
        return Validator.nullCheckValidator(value, context: context);
      }

      if (widget.maxLength != null && value!.length > widget.maxLength!) {
        return "${"youCanAdd".translate(context)} \t ${widget.maxLength} \t ${"maximumNumbersOnly".translate(context)}";
      }

      // Check if minLength is not null and value length is less than minLength
      if (widget.minLength != null && value!.length < widget.minLength!) {
        return "${widget.minLength} \t ${"numMinRequired".translate(context)}";
      }
      return null;
    }

    if (widget.validator == CustomTextFieldValidator.otpSix) {
      if ((value ??= "").length != 6) {
        return 'pleaseEnterSixDigits'.translate(context);
      }
      return null;
    }
    if (widget.validator == CustomTextFieldValidator.email) {
      return Validator.validateEmail(email: value, context: context);
    }
    if (widget.validator == CustomTextFieldValidator.slug) {
      return Validator.validateSlug(value, context: context);
    } else if (widget.validator == CustomTextFieldValidator.adTitle) {
      return Validator.validateAdTitle(value, context: context);
    }
    if (widget.validator == CustomTextFieldValidator.phoneNumber) {
      return Validator.validatePhoneNumber(value: value, context: context);
    }
    if (widget.validator == CustomTextFieldValidator.url) {
      return Validator.urlValidation(value: value ?? '', context: context);
    }
    if (widget.validator == CustomTextFieldValidator.password) {
      return Validator.validatePassword(value, context: context);
    }
    if (widget.customValidatorFn != null) {
      return widget.customValidatorFn!(value);
    }
    return null;
  }
}
