import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/data/model/category_model.dart';
import 'package:flutter/material.dart';

class SignUpCategoriesDropDownButton extends StatefulWidget {
  const SignUpCategoriesDropDownButton({
    super.key,
    required this.onChanged,
    required this.categories,
    required this.isError,
  });

  final void Function(CategoryModel) onChanged;
  final List<CategoryModel> categories;
  final bool isError;

  @override
  State<SignUpCategoriesDropDownButton> createState() =>
      _SignUpCategoriesDropDownButtonState();
}

class _SignUpCategoriesDropDownButtonState
    extends State<SignUpCategoriesDropDownButton> {
  CategoryModel? _tempSelectedCat;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CategoryModel>(
      position: PopupMenuPosition.under,
      color: const Color(0xFFEFEFEF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      constraints: const BoxConstraints(
        maxHeight: 170,
        maxWidth: 185,
      ),
      onSelected: (value) {
        widget.onChanged(value);
        setState(() {
          _tempSelectedCat = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: context.color.secondaryColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: widget.isError
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
                _tempSelectedCat?.name ?? "chooseCategory".translate(context),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: context.font.large,
                  color: context.color.textDefaultColor.withOpacity(0.7),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: context.color.textDefaultColor.withOpacity(0.5),
            )
          ],
        ),
      ),
      itemBuilder: (context) {
        return widget.categories.map<PopupMenuEntry<CategoryModel>>(
          (CategoryModel value) {
            return PopupMenuItem<CategoryModel>(
              value: value,
              child: Container(
                padding: const EdgeInsets.all(6),
                alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                  color: value.id == _tempSelectedCat?.id && value.id != null
                      ? context.color.territoryColor
                      : context.color.secondaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  value.name!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: value.id == _tempSelectedCat?.id && value.id != null
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            );
          },
        ).toList();
      },
    );
  }
}
