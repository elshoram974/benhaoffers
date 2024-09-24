import 'package:eClassify/Ui/screens/Home/home_screen.dart';
import 'package:eClassify/Utils/AppIcon.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:eClassify/data/cubits/favorite/favoriteCubit.dart';
import 'package:eClassify/data/cubits/favorite/manageFavCubit.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/Home/home_screen_section.dart';

import '../../Widgets/promoted_widget.dart';
import '../../Widgets/seller_name_container.dart';
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
                  height: 300,
                  listAxis: Axis.horizontal,
                  listSaperator: (BuildContext p0, int p1) => const SizedBox(
                    width: 14,
                  ),
                  builder: (context, int index, bool) {
                    ItemModel? item = section.sectionData?[index];

                    return Align(
                      child: ItemCard(
                        width: 190,
                        item: item,
                        bigCard: true,
                      ),
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
                  height: 300,
                  listAxis: Axis.horizontal,
                  listSaperator: (BuildContext p0, int p1) => const SizedBox(
                    width: 14,
                  ),
                  builder: (context, int index, bool) {
                    ItemModel? item = section.sectionData?[index];

                    return Align(
                      child: ItemCard(
                        item: item,
                        width: 190,
                      ),
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
                  height: 300,
                  builder: (context, int index, bool) {
                    ItemModel? item = section.sectionData?[index];

                    return Align(
                      child: ItemCard(
                        item: item,
                        width: 190,
                      ),
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
                  height: 300,
                  listAxis: Axis.horizontal,
                  listSaperator: (BuildContext p0, int p1) => const SizedBox(
                    width: 14,
                  ),
                  builder: (context, int index, bool) {
                    ItemModel? item = section.sectionData?[index];

                    return Align(
                      child: ItemCard(
                        item: item,
                        width: 190,
                      ),
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
  final bool turnUserDetailsFnOn;
  final ItemModel? item;

  const ItemCard({
    super.key,
    required this.item,
    this.width,
    this.turnUserDetailsFnOn = true,
    this.bigCard,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  double likeButtonSize = 32;
  double imageHeight = 170;

  // Use nullable bool to represent initial state

  late final bool byMe;
  @override
  void initState() {
    super.initState();
    byMe = (widget.item?.user?.id != null
            ? widget.item?.user?.id.toString()
            : widget.item?.userId) ==
        HiveUtils.getUserId();
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
                      padding: const EdgeInsets.all(9),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.5),
                        child: UiUtils.getImage(
                          widget.item?.image ?? "",
                          height: imageHeight,
                          width: imageHeight,
                          fit: BoxFit.cover,
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
                        if (widget.item != null)
                          SellerNameContainer(
                            itemModel: widget.item!,
                            turnFnOn: widget.turnUserDetailsFnOn && !byMe,
                          ),
                        Text(widget.item!.name!)
                            .firstUpperCaseWidget()
                            .bold(weight: FontWeight.w500)
                            .setMaxLines(lines: 2)
                            .size(context.font.large),
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
            favouriteButton(),
          ],
        ),
      ),
    );
  }

  Widget favouriteButton() {
    if (!byMe) {
      return BlocBuilder<FavoriteCubit, FavoriteState>(
        bloc: context.read<FavoriteCubit>(),
        builder: (context, favState) {
          bool isLike = context.select(
              (FavoriteCubit cubit) => cubit.isItemFavorite(widget.item!.id!));

          return BlocConsumer<UpdateFavoriteCubit, UpdateFavoriteState>(
            bloc: context.read<UpdateFavoriteCubit>(),
            listener: (context, state) {
              if (state is UpdateFavoriteSuccess) {
                if (state.wasProcess) {
                  context.read<FavoriteCubit>().addFavoriteitem(state.item);
                } else {
                  context.read<FavoriteCubit>().removeFavoriteItem(state.item);
                }
              }
            },
            builder: (context, state) {
              return setTopRowItem(
                  alignment: AlignmentDirectional.topEnd,
                  marginVal: 10,
                  backgroundColor: context.color.backgroundColor,
                  cornerRadius: 30,
                  childWidget: InkWell(
                    onTap: () {
                      UiUtils.checkUser(
                          onNotGuest: () {
                            context.read<UpdateFavoriteCubit>().setFavoriteItem(
                                  item: widget.item!,
                                  type: isLike ? 0 : 1,
                                );
                          },
                          context: context);
                    },
                    child: state is UpdateFavoriteInProgress &&
                            state.itemId == widget.item?.id
                        ? SizedBox.square(
                            dimension: 22,
                            child: UiUtils.progress(
                              height: 22,
                              width: 22,
                            ),
                          )
                        : UiUtils.getSvg(
                            isLike ? AppIcons.like_fill : AppIcons.like,
                            color: context.color.territoryColor,
                            width: 22,
                            height: 22),
                  ));
            },
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget setTopRowItem(
      {required AlignmentDirectional alignment,
      required double marginVal,
      required double cornerRadius,
      required Color backgroundColor,
      required Widget childWidget}) {
    return Align(
        alignment: alignment,
        child: Container(
            margin: EdgeInsets.all(marginVal),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cornerRadius),
                color: backgroundColor),
            child: childWidget)
        //TODO: swap icons according to liked and non-liked -- favorite_border_rounded and favorite_rounded
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
