import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../Utils/ui_utils.dart';
import '../../../../Widgets/DynamicField/dynamic_field.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../custom_field.dart';

class CustomFieldWebsite extends CustomField {
  @override
  String type = "websitefield";
  String initialValue = "";

  @override
  void init() {
    
    if (parameters['isEdit'] == true) {
      if (parameters['value'] != null) {
        if ((parameters['value'] as List).isNotEmpty) {
          initialValue = parameters['value'][0].toString();
          if(initialValue.isNotEmpty) setData();
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
            Container(
              width: 48.rw(context),
              height: 48.rh(context),
              decoration: BoxDecoration(
                color: context.color.territoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 24,
                width: 24,
                child: FittedBox(
                  fit: BoxFit.none,
                  child: UiUtils.imageType(parameters['image'],
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      color: context.color.textDefaultColor),
                ),
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
        CustomTextFormField(
          action: TextInputAction.next,
          hintText: "Ex: https://examble.com",
          maxLine: 1,
          capitalization: TextCapitalization.none,
          fillColor: context.color.secondaryColor,
          borderColor: context.color.borderColor.darken(30),
          keyboard: TextInputType.url,
          validator: parameters['required'] == 1 || initialValue.isNotEmpty? CustomTextFieldValidator.url : null,
          onChange: (val) {
            initialValue = val;
            setData();
          },
        ),
      ],
    );
  }

  void setData() {
    AbstractField.fieldsData.addAll(Map<String, dynamic>.from({
      parameters['id'].toString(): [initialValue]
    }));
  }
}
