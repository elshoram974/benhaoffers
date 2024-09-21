import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/validator.dart';
import 'package:flutter/material.dart';

import '../../../../../../Utils/ui_utils.dart';
import '../../../../Widgets/DynamicField/dynamic_field.dart';
import '../custom_field.dart';

class CustomFieldDropdown extends CustomField {
  @override
  String type = "dropdown";
  String? selected;

  @override
  void init() {
    if (parameters['isEdit'] == true) {
      if (parameters['value'] != null) {
        if ((parameters['value'] as List).isNotEmpty) {
          selected = parameters['value'][0].toString();
        }
      }
    } else {
      /* selected = parameters['values'][0];
      AbstractField.fieldsData.addAll({
        parameters['id'].toString(): [selected],
      });*/

      selected = ""; // Ensure selected is null initially
      // Ensure blank option is included in the values
      /* if (!(parameters['values'] as List).contains("")) {
        (parameters['values'] as List).insert(0, "");
      }*/
    }

    update(() {});
    super.init();
  }

  @override
  Widget render() {
    return CustomValidator<String>(
        initialValue: selected,
        validator: (String? value) {
          if (parameters['required'] != 1) {
            return null;
          }

          if (value?.isNotEmpty == true) {
            return null;
          }

          return "pleaseSelectValue".translate(context);
        },
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(height: 14.rh(context)),
              SizedBox(
                width: double.infinity,
                child: PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  color: const Color(0xFFEFEFEF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 170,
                    maxWidth: 185,
                    minWidth: 185,
                  ),
                  onSelected: (value) {
                    selected = value.toString();
                    state.didChange(selected);
                    update(() {});
                    AbstractField.fieldsData.addAll({
                      parameters['id'].toString(): [selected],
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: context.color.secondaryColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: state.hasError
                              ? context.color.error
                              : context.color.borderColor.darken(10),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selected?.isNotEmpty == true
                                ? selected
                                : parameters['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: context.font.large,
                              color: context.color.textDefaultColor
                                  .withOpacity(0.7),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color:
                              context.color.textDefaultColor.withOpacity(0.5),
                        )
                      ],
                    ),
                  ),
                  itemBuilder: (context) {
                    return (parameters['values'] as List<dynamic>)
                        .map<PopupMenuEntry<String>>(
                      (dynamic value) {
                        return PopupMenuItem<String>(
                          value: value,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            alignment: AlignmentDirectional.centerStart,
                            decoration: BoxDecoration(
                              color: value == selected && selected != null
                                  ? context.color.territoryColor
                                  : context.color.secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: value == selected && selected != null
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList();
                  },
                ),
                //  DropdownButton(
                //   value: selected?.isEmpty == true ? null : selected,
                //   dropdownColor: context.color.secondaryColor,
                //   isExpanded: true,
                //   hint: parameters['name'] == null
                //       ? null
                //       : Text(parameters['name']),
                //   padding: const EdgeInsets.symmetric(vertical: 5),
                //   icon: SvgPicture.asset(AppIcons.downArrow),
                //   isDense: true,
                //   borderRadius: BorderRadius.circular(10),
                //   style: TextStyle(
                //     color: context.color.textLightColor,
                //     fontSize: context.font.large,
                //   ),
                //   underline: const SizedBox.shrink(),
                //   items: (parameters['values'] as List<dynamic>)
                //       .map<DropdownMenuItem<dynamic>>((dynamic e) {
                //     return DropdownMenuItem<dynamic>(
                //       value: e,
                //       child: Text(e),
                //     );
                //   }).toList(),
                //   onChanged: (v) {
                //     selected = v.toString();
                //     state.didChange(selected);
                //     update(() {});
                //     AbstractField.fieldsData.addAll({
                //       parameters['id'].toString(): [selected],
                //     });
                //   },
                // ),
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
        });
  }
}
