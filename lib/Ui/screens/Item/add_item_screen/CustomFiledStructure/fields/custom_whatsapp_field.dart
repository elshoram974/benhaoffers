import 'package:country_picker/country_picker.dart';
import 'package:device_region/device_region.dart';
import 'package:eClassify/Utils/AppIcon.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../Utils/constant.dart';
import '../../../../../../Utils/ui_utils.dart';
import '../../../../Widgets/DynamicField/dynamic_field.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../custom_field.dart';

class CustomFieldWhatsapp extends CustomField {
  @override
  String type = "whatsappfield";
  String? phone, countryCode;
  final TextEditingController controller = TextEditingController();

  @override
  void init() {
    print("parameters $parameters");

    if (parameters['isEdit'] == true) {
      if ((parameters['value'] as List?)?.isNotEmpty == true) {
        phone = parameters['value'][0].toString();
      }
    }

    getSimCountry().then((value) {
      print("value country***$value");
      countryCode = value.phoneCode;
      phone = phone?.substring(
          "https://api.whatsapp.com/send/?phone=$countryCode".length);
      phone = phone?.replaceAll(
          "&text=Hello%21&type=phone_number&app_absent=0", '');
      if (phone?.isNotEmpty == true) {
        controller.text = phone!;
        setData();
      }
      update(() {});
    });
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
        SizedBox(height: 14.rh(context)),
        CustomTextFormField(
          action: TextInputAction.next,
          controller: controller,
          fillColor: context.color.secondaryColor,
          borderColor: context.color.borderColor.darken(30),
          suffixWithBorder: UiUtils.getSvg(AppIcons.whatsappIcon),
          formaters: [FilteringTextInputFormatter.digitsOnly],
          keyboard: TextInputType.phone,
          validator: parameters['required'] == 1 || phone?.isNotEmpty == true
              ? CustomTextFieldValidator.phoneNumber
              : null,
          onChange: (val) {
            phone = val;
            phone = phone!.replaceFirst(RegExp(r'^0+'), '');
            setData();
          },
          fixedPrefix: SizedBox(
            width: 55,
            child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: GestureDetector(
                  onTap: () {
                    showCountryCode();
                  },
                  child: Container(
                    // color: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: Center(
                        child: Text("+$countryCode")
                            .size(context.font.large)
                            .centerAlign()),
                  ),
                )),
          ),
          hintText: "whatsappNumber".translate(context),
        ),
      ],
    );
  }

  void setData() {
    AbstractField.fieldsData.addAll(Map<String, dynamic>.from({
      parameters['id'].toString(): [
        "https://api.whatsapp.com/send/?phone=$countryCode$phone&text=Hello%21&type=phone_number&app_absent=0"
      ]
    }));
  }

  void showCountryCode() {
    showCountryPicker(
      context: context,
      showWorldWide: false,
      showPhoneCode: true,
      countryListTheme:
          CountryListThemeData(borderRadius: BorderRadius.circular(11)),
      onSelect: (Country value) {
        countryCode = value.phoneCode;
        setData();
        update(() {});
      },
    );
  }

  /// it will return user's sim cards country code
  Future<Country> getSimCountry() async {
    List<Country> countryList = CountryService().getAll();
    String? simCountryCode;

    try {
      simCountryCode = await DeviceRegion.getSIMCountryCode();
      print("simCountryCode***$simCountryCode");
    } catch (e) {}

    Country simCountry = countryList.firstWhere(
      (element) {
        if (Constant.isDemoModeOn) {
          return countryList.any(
            (element) => element.phoneCode == Constant.defaultCountryCode,
          );
        } else {
          return element.phoneCode == simCountryCode;
        }
      },
      orElse: () {
        return countryList
            .where(
              (element) => element.phoneCode == Constant.defaultCountryCode,
            )
            .first;
      },
    );

    if (Constant.isDemoModeOn) {
      simCountry = countryList
          .where((element) => element.phoneCode == Constant.demoCountryCode)
          .first;
    }

    return simCountry;
  }
}
