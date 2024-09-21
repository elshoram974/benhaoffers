
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:flutter/material.dart';

import '../../../../../../Utils/ui_utils.dart';
import '../../../../Widgets/DynamicField/dynamic_field.dart';
import '../custom_field.dart';

class CustomFieldText extends CustomField {
  @override
  String type = "textbox";
  String initialValue = "";

  @override
  void init() {
    //
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
                fit: BoxFit.scaleDown,
                child: UiUtils.imageType(parameters['image'],
                    width: 24.rw(context),
                    height: 24.rw(context),
                    fit: BoxFit.cover,
                    color: context.color.textDefaultColor),
              ),
            ),
            SizedBox(
              width: 10.rw(context),
            ),
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
          action: TextInputAction.newline,
          initController: parameters['value'] != null ? true : false,
          value: initialValue,
          hintText: "writeSomething".translate(context),
          required: parameters['required'] == 1 ? true : false,
          id: parameters['id'],
          maxLen: 125,
          maxLine: 3,
          keyboardType: TextInputType.multiline,
          capitalization: TextCapitalization.sentences,
        )
      ],
    );
  }
}
