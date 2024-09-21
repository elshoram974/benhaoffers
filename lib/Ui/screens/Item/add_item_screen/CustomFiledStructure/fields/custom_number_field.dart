import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../Utils/ui_utils.dart';
import '../../../../Widgets/DynamicField/dynamic_field.dart';
import '../../../../Widgets/custom_text_form_field.dart';
import '../custom_field.dart';

class CustomNumberField extends CustomField {
  @override
  String type = "number";
  String initialValue = "";

  @override
  void init() {
    if (parameters['isEdit'] == true) {
      if (parameters['value'] != null) {
        if ((parameters['value'] as List).isNotEmpty) {
          initialValue = parameters['value'][0].toString();
          update(() {});
        }
      }
    }
    super.init();
  }

  @override
  Widget render() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox.square(
              dimension: 24.rw(context),
              child: FittedBox(
                fit: BoxFit.none,
                child: UiUtils.imageType(parameters['image'],
                    width: 24.rw(context),
                    height: 24.rw(context),
                    fit: BoxFit.cover,
                    color: context.color.textDefaultColor),
              ),
            ),
            SizedBox(width: 10.rw(context)),
            Text(parameters['name'])
                .size(context.font.large)
                .bold(weight: FontWeight.w500)
                .color(context.color.textColorDark)
          ],
        ),
        SizedBox(
          height: 14.rh(context),
        ),
        CustomTextFieldDynamic(
          initController: parameters['value'] != null ? true : false,
          value: initialValue,
          validator: CustomTextFieldValidator.minAndMixLen,
          maxLen: parameters['max_length'],
          minLen: parameters['min_length'],
          hintText: "addNumerical".translate(context),
          formaters: [
            FilteringTextInputFormatter.allow(
              RegExp("[0-9]"),
            ),
          ],
          action: TextInputAction.next,
          keyboardType: TextInputType.number,
          required: parameters['required'] == 1 ? true : false,
          id: parameters['id'],
        ),
      ],
    );
  }
}
