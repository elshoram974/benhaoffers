import 'package:eClassify/Ui/screens/Item/add_item_screen/CustomFiledStructure/fields/custom_checkbox_field.dart';

import 'custom_field.dart';
import 'fields/custom_date_input_field.dart';
import 'fields/custom_dropdown_field.dart';
import 'fields/custom_file_field.dart';
import 'fields/custom_number_field.dart';
import 'fields/custom_radio_field.dart';
import 'fields/custom_text_field.dart';
import 'fields/custom_website_field.dart';
import 'fields/custom_whatsapp_field.dart';

class KRegisteredFields {
  ///ADD NEW FIELD HERE
  final List<CustomField> _fields = [
    CustomFieldText(), //text field
    CustomFieldDropdown(), //dropdown field
    CustomNumberField(),
    CustomCheckboxField(),
    CustomRadioField(),
    CustomFileField(),
    CustomDateInputField(),
    CustomFieldWhatsapp(),
    CustomFieldWebsite(),
  ];

  CustomField? get(String type) {
    CustomField? selectedField;
    for (CustomField field in _fields) {
      if (field.type == type) {
        selectedField = field;
      }
    }

    return selectedField;
  }
}
