import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Utils/AppIcon.dart';
import '../../../Utils/helper_utils.dart';
import '../../../Utils/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';
import '../../../data/cubits/Home/fetch_item_from_seller_cubit.dart';
import '../../../data/model/item/item_model.dart';
import '../../../exports/main_export.dart';
import '../../../utils/Extensions/extensions.dart';

import '../../../utils/responsiveSize.dart';
import '../../../utils/ui_utils.dart';
import '../Home/Widgets/home_sections_adapter.dart';
import '../Widgets/Errors/no_data_found.dart';
import '../widgets/AnimatedRoutes/blur_page_route.dart';
import '../widgets/shimmerLoadingContainer.dart';

class SellerDetailsScreen extends StatefulWidget {
  final ItemModel model;

  const SellerDetailsScreen({super.key, required this.model});

  @override
  SellerDetailsScreenState createState() => SellerDetailsScreenState();

  static Route route(RouteSettings routeSettings) {
    Map? arguments = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => BlocProvider(
        create: (context) => FetchItemFromSellerCubit(),
        child: SellerDetailsScreen(model: arguments?['model']),
      ),
    );
  }
}

class SellerDetailsScreenState extends State<SellerDetailsScreen> {
  late final User seller = widget.model.user!;

  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_loadMore);

    context
        .read<FetchItemFromSellerCubit>()
        .fetchItemFromSeller(sellerId: seller.id!);
  }

  @override
  void dispose() {
    controller.removeListener(_loadMore);
    controller.dispose();
    super.dispose();
  }

  void _loadMore() async {
    if (controller.isEndReached()) {
      if (context.read<FetchItemFromSellerCubit>().hasMoreData()) {
        context
            .read<FetchItemFromSellerCubit>()
            .fetchItemFromSellerMore(sellerId: seller.id!);
        // context.read<FetchItemFromSellerCubit>().fetchItemFromCategoryMore(
        //     catId: int.parse(
        //       widget.categoryId,
        //     ),
        //     search: searchController.text,
        //     sortBy: sortBy);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return bodyWidget();
  }

  Widget bodyWidget() {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(
        context: context,
        statusBarColor: context.color.secondaryColor,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.buildAppBar(
          context,
          showBackButton: true,
          title: seller.name,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<FetchItemFromSellerCubit>()
                .fetchItemFromSeller(sellerId: seller.id!);
          },
          color: context.color.territoryColor,
          child: ListView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            children: [
              sellerDetails(),
              fetchItems(),
              loadingMoreProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingMoreProgress() {
    return BlocBuilder<FetchItemFromSellerCubit, FetchItemFromSellerState>(
      builder: (context, state) {
        if (state is FetchItemFromSellerSuccess) {
          if (state.isLoadingMore) return UiUtils.progress();
        }
        return const SizedBox();
      },
    );
  }

  Padding sellerDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          SizedBox.square(
            dimension: 160.rh(context),
            child: Hero(
              tag: seller.profile ?? seller.email!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: seller.profile != null && seller.profile?.trim() != ""
                    ? UiUtils.getImage(seller.profile!, fit: BoxFit.fill)
                    : UiUtils.getSvg(
                        AppIcons.defaultPersonLogo,
                        color: context.color.territoryColor,
                        fit: BoxFit.none,
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(seller.projectName!).bold().size(context.font.larger),
                  Text(seller.name!).bold().size(context.font.large),
                  Text(seller.email!)
                      .color(context.color.textLightColor)
                      .size(context.font.small)
                ]),
                const Spacer(),
                setIconButtons(
                  assetName: AppIcons.message,
                  onTap: () {
                    HelperUtils.launchPathURL(
                        isTelephone: false,
                        isSMS: true,
                        isMail: false,
                        value: widget.model.contact!,
                        context: context);
                  },
                ),
                SizedBox(width: 10.rw(context)),
                setIconButtons(
                  assetName: AppIcons.call,
                  onTap: () {
                    HelperUtils.launchPathURL(
                        isTelephone: true,
                        isSMS: false,
                        isMail: false,
                        value: widget.model.contact!,
                        context: context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget setIconButtons({
    required String assetName,
    required void Function() onTap,
    Color? color,
    double? height,
    double? width,
  }) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.color.borderColor.darken(30))),
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
                onTap: onTap,
                child: SvgPicture.asset(
                  assetName,
                  colorFilter: color == null
                      ? ColorFilter.mode(
                          context.color.territoryColor, BlendMode.srcIn)
                      : ColorFilter.mode(color, BlendMode.srcIn),
                ))));
  }

  Widget fetchItems() {
    return BlocBuilder<FetchItemFromSellerCubit, FetchItemFromSellerState>(
        builder: (context, state) {
      if (state is FetchItemFromSellerInProgress) {
        return GridView.builder(
          itemCount: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
              crossAxisCount: 2,
              height: MediaQuery.of(context).size.height / 3.rh(context),
              mainAxisSpacing: 7,
              crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            return const ItemCardShimmer();
          },
        );
      }

      if (state is FetchItemFromSellerFailure) {
        return Center(
          child: Text(state.errorMessage),
        );
      }
      if (state is FetchItemFromSellerSuccess) {
        if (state.itemModel.isEmpty) {
          return Center(
            child: NoDataFound(
              onTap: () {
                context
                    .read<FetchItemFromSellerCubit>()
                    .fetchItemFromSeller(sellerId: seller.id!);
              },
            ),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
              crossAxisCount: context.resValue<int>(
                inPhone: 2,
                inTablet: 3,
                inDesktop: 4,
              ),
              height: 300,
              mainAxisSpacing: 7,
              crossAxisSpacing: 10),
          itemCount: state.itemModel.length,
          itemBuilder: (context, index) {
            ItemModel item = state.itemModel[index];

            return Align(
              child: ItemCard(
                item: item,
                turnUserDetailsFnOn: false,
                width: 190,
              ),
            );
          },
        );
      }
      return Container();
    });
  }

  Widget buildItemsShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120.rh(context),
        decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: context.color.borderColor),
            color: context.color.secondaryColor,
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            CustomShimmer(
              height: 120.rh(context),
              width: 100.rw(context),
            ),
            SizedBox(
              width: 10.rw(context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomShimmer(
                  width: 100.rw(context),
                  height: 10,
                  borderRadius: 7,
                ),
                CustomShimmer(
                  width: 150.rw(context),
                  height: 10,
                  borderRadius: 7,
                ),
                CustomShimmer(
                  width: 120.rw(context),
                  height: 10,
                  borderRadius: 7,
                ),
                CustomShimmer(
                  width: 80.rw(context),
                  height: 10,
                  borderRadius: 7,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
