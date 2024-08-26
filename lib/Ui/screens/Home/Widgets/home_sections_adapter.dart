import 'package:eClassify/Ui/screens/Home/home_screen.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/Home/home_screen_section.dart';

import '../../Widgets/promoted_widget.dart';
import '../../widgets/shimmerLoadingContainer.dart';
import 'grid_list_adapter.dart';

class HomeSectionsAdapter extends StatelessWidget {
  final HomeScreenSection section;

  const HomeSectionsAdapter({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    if (section.style == "style_1") {
      return section.sectionData!.isNotEmpty
          ? Column(
              children: [
                TitleHeader(
                  title: section.title ?? "",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.sectionWiseItemsScreen,
                        arguments: {
                          "title": section.title,
                          "sectionId": section.sectionId,
                        });
                  },
                  // section: section,
                ),
                GridListAdapter(
                  type: ListUiType.List,
                  height: MediaQuery.sizeOf(context).height / 3.rh(context),
                  listAxis: Axis.horizontal,
                  listSaperator: (BuildContext p0, int p1) => const SizedBox(
                    width: 14,
                  ),
                  builder: (context, int index, bool) {
                    ItemModel? item = section.sectionData?[index];

                    return ItemCard(
                      width: MediaQuery.sizeOf(context).width / 2.rw(context),
                      item: item,
                      bigCard: true,
                    );
                  },
                  total: section.sectionData?.length ?? 0,
                ),
              ],
            )
          : const SizedBox.shrink();
    } else if (section.style == "style_2") {
      return section.sectionData!.isNotEmpty
          ? Column(
              children: [
                TitleHeader(
                  title: section.title ?? "",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.sectionWiseItemsScreen,
                        arguments: {
                          "title": section.title,
                          "sectionId": section.sectionId,
                        });
                  },
                ),
                GridListAdapter(
                  type: ListUiType.List,
                  height: MediaQuery.sizeOf(context).height / 3.rh(context),
                  listAxis: Axis.horizontal,
                  listSaperator: (BuildContext p0, int p1) => const SizedBox(
                    width: 14,
                  ),
                  builder: (context, int index, bool) {
                    ItemModel? item = section.sectionData?[index];

                    return ItemCard(
                      item: item,
                      width: MediaQuery.sizeOf(context).width / 2.3.rw(context),
                    );
                  },
                  total: section.sectionData?.length ?? 0,
                ),
              ],
            )
          : const SizedBox.shrink();
    } else if (section.style == "style_3") {
      return section.sectionData!.isNotEmpty
          ? Column(
              children: [
                TitleHeader(
                  title: section.title ?? "",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.sectionWiseItemsScreen,
                        arguments: {
                          "title": section.title,
                          "sectionId": section.sectionId,
                        });
                  },
                ),
                GridListAdapter(
                  type: ListUiType.Grid,
                  crossAxisCount: 2,
                  height: MediaQuery.sizeOf(context).height / 3.rh(context),
                  builder: (context, int index, bool) {
                    ItemModel? item = section.sectionData?[index];

                    return ItemCard(
                      item: item,
                      width: 192,
                    );
                  },
                  total: section.sectionData?.length ?? 0,
                ),
              ],
            )
          : const SizedBox.shrink();
    } else if (section.style == "style_4") {
      return section.sectionData!.isNotEmpty
          ? Column(
              children: [
                TitleHeader(
                  title: section.title ?? "",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.sectionWiseItemsScreen,
                        arguments: {
                          "title": section.title,
                          "sectionId": section.sectionId,
                        });
                  },
                ),
                GridListAdapter(
                  type: ListUiType.List,
                  height: MediaQuery.sizeOf(context).height / 3.rh(context),
                  listAxis: Axis.horizontal,
                  listSaperator: (BuildContext p0, int p1) => const SizedBox(
                    width: 14,
                  ),
                  builder: (context, int index, bool) {
                    ItemModel? item = section.sectionData?[index];

                    return ItemCard(
                      item: item,
                      width: 192,
                    );
                  },
                  total: section.sectionData?.length ?? 0,
                ),
              ],
            )
          : const SizedBox.shrink();
    } else {
      return Container();
    }
  }
}

class TitleHeader extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool? hideSeeAll;

  const TitleHeader({
    super.key,
    required this.title,
    required this.onTap,
    this.hideSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          top: 18, bottom: 12, start: sidePadding, end: sidePadding),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(title)
                .size(context.font.large)
                .bold(weight: FontWeight.w600)
                .setMaxLines(lines: 1),
          ),
          const Spacer(),
          if (!(hideSeeAll ?? false))
            GestureDetector(
              onTap: onTap,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2.2),
                  child: Text("seeAll".translate(context))
                      .size(context.font.smaller + 1)),
            )
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final double? width;
  final bool? bigCard;
  final ItemModel? item;

  const ItemCard({
    super.key,
    required this.item,
    this.width,
    this.bigCard,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  double likeButtonSize = 32;
  double imageHeight = 147;

  // Use nullable bool to represent initial state

  @override
  void initState() {
    super.initState();
    // Initialize the isLiked status based on the existing favorite state
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.adDetailsScreen, arguments: {
          "model": widget.item,
        });
      },
      child: Container(
        width: widget.width ?? 250,
        decoration: BoxDecoration(
          color: context.color.cardBackgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: UiUtils.getImage(
                          widget.item?.image ?? "",
                          height: imageHeight,
                          width: imageHeight,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    if (widget.item?.isFeature ?? false)
                      const PositionedDirectional(
                          start: 10,
                          top: 5,
                          child: PromotedCard(type: PromoteCardType.icon)),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: context.color.territoryColor,
                            borderRadius: BorderRadius.circular(500),
                          ),
                          child: Text("${widget.item?.user?.name}")
                              .bold()
                              .color(Colors.white)
                              .size(context.font.small),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(widget.item!.name!)
                              .firstUpperCaseWidget()
                              .bold()
                              .setMaxLines(lines: 2)
                              .size(context.font.large),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.visibility_outlined,
                                      size: widget.bigCard == true ? 13 : 11,
                                      color: context.color.textDefaultColor
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                              "${widget.item?.views} ${"view".translate(context)}")
                                          .size((widget.bigCard == true)
                                              ? context.font.small
                                              : context.font.smaller)
                                          .color(context.color.textDefaultColor
                                              .withOpacity(0.5))
                                          .setMaxLines(lines: 2),
                                    )
                                  ],
                                ),
                              ),
                              if (widget.item?.endDate != null)
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: widget.bigCard == true ? 13 : 11,
                                        color: context.color.textDefaultColor
                                            .withOpacity(0.5),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                                "${"daysRemining".translate(context)} ${widget.item?.endDate?.difference(DateTime.now()).inDays.abs()} ${"days".translate(context)}")
                                            .size((widget.bigCard == true)
                                                ? context.font.small
                                                : context.font.smaller)
                                            .color(context
                                                .color.textDefaultColor
                                                .withOpacity(0.5))
                                            .setMaxLines(lines: 2),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // favButton(),
          ],
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ItemCardShimmer extends StatelessWidget {
  final double imageHeight = 147;
  final double? width;

  const ItemCardShimmer({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 250,
      decoration: BoxDecoration(
        color: context.color.borderColor.darken(30),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomShimmer(
                height: imageHeight,
                width: imageHeight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer(
                  width: 100.rw(context),
                  height: 10,
                  borderRadius: 7,
                ),
                SizedBox(height: 20.rw(context)),
                const CustomShimmer(height: 15, borderRadius: 7),
                SizedBox(height: 20.rw(context)),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomShimmer(height: 10, borderRadius: 7),
                      ),
                      Expanded(
                        child: CustomShimmer(height: 10, borderRadius: 7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
