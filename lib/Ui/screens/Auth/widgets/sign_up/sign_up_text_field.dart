import 'package:eClassify/Ui/screens/Widgets/custom_text_form_field.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpTextField extends StatelessWidget {
  const SignUpTextField({
    super.key,
    this.focusNode,
    this.action,
    this.controller,
    this.validator,
    this.hintText,
    this.keyboard,
    this.formaters,
    this.suffix,
    this.obscureText,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.customValidatorFn,
  });

  final FocusNode? focusNode;
  final TextInputAction? action;
  final TextEditingController? controller;
  final CustomTextFieldValidator? validator;
  final String? hintText;
  final Widget? suffix;
  final bool? obscureText;
  final List<TextInputFormatter>? formaters;
  final TextInputType? keyboard;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? customValidatorFn;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      fillColor: context.color.secondaryColor,
      validator: validator,
      action: action ?? TextInputAction.next,
      hintText: hintText,
      keyboard: keyboard,
      formaters: formaters,
      borderColor: context.color.borderColor.darken(10),
      borderRadius: 8,
      suffix: suffix,
      obscureText: obscureText,
      onEditingComplete: onEditingComplete,
      customValidatorFn: customValidatorFn,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }
}
