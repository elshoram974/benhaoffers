import 'package:eClassify/Ui/screens/Home/home_screen.dart';
import 'package:eClassify/Utils/AppIcon.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/category_model.dart';
import '../../../../exports/main_export.dart';
import '../../Widgets/Errors/no_data_found.dart';
import '../../main_activity.dart';
import 'category_home_card.dart';
import 'home_sections_adapter.dart';

class CategoryWidgetHome extends StatelessWidget {
  const CategoryWidgetHome({super.key});

  @override
  Widget build(BuildContext context) {
    final FetchCategoryCubit c = BlocProvider.of<FetchCategoryCubit>(context);
    return BlocBuilder<FetchCategoryCubit, FetchCategoryState>(
      builder: (context, state) {
        final List<CategoryModel> list = [];
        if (state is FetchCategorySuccess) {
          list.addAll(c.allCategories.categories);
          if (c.allCategories.categories.length > 15) {
            list.removeRange(15, c.allCategories.categories.length);
          }
          if (list.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  TitleHeader(
                    title: "categoriesLbl".translate(context),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.categories,
                          arguments: {"from": Routes.home}).then(
                        (dynamic value) {
                          if (value != null) {
                            selectedCategory = value;
                            //setState(() {});
                          }
                        },
                      );
                    },
                    // section: section,
                  ),
                  SizedBox(
                    width: context.screenWidth,
                    height: AppSettings.makeHomeCategoryGridView
                        ? null
                        : 85.rw(context),
                    child: GridView.builder(
                      gridDelegate: AppSettings.makeHomeCategoryGridView
                          ? const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            )
                          : const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.35,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                      physics: AppSettings.makeHomeCategoryGridView
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: sidePadding,
                      ),
                      shrinkWrap: true,
                      scrollDirection: AppSettings.makeHomeCategoryGridView
                          ? Axis.vertical
                          : Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == list.length) {
                          if (list.length > 14) return moreCategory();
                          return null;
                        } else {
                          return CategoryHomeCard(
                            title: list[index].name!,
                            url: list[index].url!,
                            onTap: () {
                              if (list[index].children!.isNotEmpty) {
                                Navigator.pushNamed(
                                    context, Routes.subCategoryScreen,
                                    arguments: {
                                      "categoryList": list[index].children,
                                      "catName": list[index].name,
                                      "catId": list[index].id,
                                      "categoryIds": [list[index].id.toString()]
                                    });
                              } else {
                                Navigator.pushNamed(context, Routes.itemsList,
                                    arguments: {
                                      'catID': list[index].id.toString(),
                                      'catName': list[index].name,
                                      "categoryIds": [list[index].id.toString()]
                                    });
                              }
                            },
                          );
                        }
                      },
                      itemCount: list.length + 1,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: NoDataFound(
                onTap: () {},
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget moreCategory() {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.categories,
              arguments: {"from": Routes.home}).then(
            (dynamic value) {
              if (value != null) {
                selectedCategory = value;
                //setState(() {});
              }
            },
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: context.color.borderColor.darken(60), width: 1),
                    boxShadow: [
                        BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ],
                    color: context.color.secondaryColor,
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        // color: Colors.blue,
                        width: 48,
                        height: 48,
                        child: Center(
                          child: RotatedBox(
                              quarterTurns: 1,
                              child: UiUtils.getSvg(AppIcons.more,
                                  color: context.color.territoryColor)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text("more".translate(context))
                    .centerAlign()
                    .setMaxLines(lines: 2)
                    .size(context.font.smaller)
                    .color(
                      context.color.textDefaultColor,
                    ),
              ))
            ],
          ),
        ),
      );
    });
  }
}
