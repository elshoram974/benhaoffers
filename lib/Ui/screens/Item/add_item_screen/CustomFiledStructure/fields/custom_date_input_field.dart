import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../Utils/ui_utils.dart';
import '../../../../../../Utils/validator.dart';
import '../../../../Widgets/DynamicField/dynamic_field.dart';
import '../custom_field.dart';

class CustomDateInputField extends CustomField {
  @override
  String type = "dateinput";
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
    late DateTime? initDate = DateTime.tryParse(initialValue);
    late String val;
    if (initDate == null) {
      val = "chooseDate".translate(context);
    } else {
      val = DateFormat.yMMMd().format(initDate);
      addDate(parameters, initialValue);
    }
    return CustomValidator<String>(
      initialValue: initialValue,
      validator: (String? value) {
        if (parameters['required'] != 1) {
          return null;
        }

        if (value?.isNotEmpty == true) {
          return null;
        }

        return "pleaseSelectDate".translate(context);
      },
      builder: (state) {
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
                SizedBox(
                  width: 10.rw(context),
                ),
                Text(parameters['name'])
                    .size(context.font.large)
                    .bold(weight: FontWeight.w500)
                    .color(context.color.textColorDark)
              ],
            ),
            SizedBox(height: 14.rh(context)),
            GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  initialDate: initDate ?? DateTime.now(),
                ).then((e) {
                  if (e != null) {
                    initDate = e;
                    val = DateFormat.yMMMd().format(e);
                    initialValue = e.toIso8601String();
                    addDate(parameters, initialValue);
                    state.didChange(initialValue);
                  }
                });
              },
              child: Container(
                height: 48,
                width: double.infinity,
                padding: const EdgeInsetsDirectional.only(start: 14.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: context.color.secondaryColor,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    border: Border.all(
                      width: 1,
                      color: state.hasError
                          ? context.color.error
                          : context.color.borderColor.darken(30),
                    )),
                child: Text(
                  val,
                  style: TextStyle(
                    color: state.hasError
                        ? context.color.error
                        : context.color.textColorDark.withOpacity(0.7),
                    fontSize: context.font.large,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: state.hasError,
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
      },
    );
  }
}

void addDate(Map parameters, String value) {
  AbstractField.fieldsData.addAll(Map<String, dynamic>.from({
    parameters['id'].toString(): [value]
  }));
}
