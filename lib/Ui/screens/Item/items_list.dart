import 'dart:async';

import 'package:eClassify/Utils/helper_utils.dart';
import 'package:eClassify/data/Repositories/Item/item_repository.dart';
import 'package:eClassify/data/helper/widgets.dart';
import 'package:eClassify/data/model/category_model.dart';
import 'package:eClassify/data/model/data_output.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart' as urllauncher;

import '../../../Utils/AppIcon.dart';
import '../../../Utils/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';
import '../../../data/cubits/item/fetch_slider_vendor_category.dart';
import '../../../data/model/home_slider.dart';
import '../../../data/model/item/item_model.dart';
import '../../../data/model/item_filter_model.dart';
import '../../../exports/main_export.dart';
import '../../../utils/Extensions/extensions.dart';
import '../../../utils/api.dart';

import '../../../utils/responsiveSize.dart';
import '../../../utils/ui_utils.dart';
import '../Home/Widgets/home_sections_adapter.dart';
import '../Home/home_screen.dart';
import '../Widgets/Errors/no_data_found.dart';
import '../home/Widgets/item_horizontal_card.dart';
import '../main_activity.dart';
import '../widgets/AnimatedRoutes/blur_page_route.dart';

class ItemsList extends StatefulWidget {
  final String categoryId, categoryName;
  final List<String> categoryIds;

  const ItemsList(
      {super.key,
      required this.categoryId,
      required this.categoryName,
      required this.categoryIds});

  @override
  ItemsListState createState() => ItemsListState();

  static Route route(RouteSettings routeSettings) {
    Map? arguments = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => BlocProvider(
        create: (context) => FetchSliderVendorFromCategoryCubit(),
        child: ItemsList(
          categoryId: arguments?['catID'] as String,
          categoryName: arguments?['catName'],
          categoryIds: arguments?['categoryIds'],
        ),
      ),
    );
  }
}

class ItemsListState extends State<ItemsList> {
  late ScrollController controller;
  static TextEditingController searchController = TextEditingController();
  bool isFocused = false;
  bool isList = false;
  String previousSearchQuery = "";
  Timer? _searchDelay;
  String? sortBy;
  ItemFilterModel? filter;

  @override
  void initState() {
    super.initState();
    searchbody = {};
    Constant.itemFilter = null;
    searchController = TextEditingController();
    searchController.addListener(searchItemListener);
    controller = ScrollController()..addListener(_loadMore);

    context.read<FetchItemFromCategoryCubit>().fetchItemFromCategory(
        categoryId: int.parse(
          widget.categoryId,
        ),
        search: "");

    context
        .read<FetchSliderVendorFromCategoryCubit>()
        .fetchSliderVendorFromCategory(
          int.parse(widget.categoryId),
        );

    Future.delayed(Duration.zero, () {
      selectedcategoryId = widget.categoryId;
      selectedcategoryName = widget.categoryName;
      searchbody[Api.categoryId] = widget.categoryId;
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.removeListener(_loadMore);
    controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  //this will listen and manage search
  void searchItemListener() {
    _searchDelay?.cancel();
    searchCallAfterDelay();
  }

//This will create delay so we don't face rapid api call
  void searchCallAfterDelay() {
    _searchDelay = Timer(const Duration(milliseconds: 500), itemSearch);
  }

  ///This will call api after some delay
  void itemSearch() {
    // if (searchController.text.isNotEmpty) {
    if (previousSearchQuery != searchController.text) {
      context.read<FetchItemFromCategoryCubit>().fetchItemFromCategory(
          categoryId: int.parse(
            widget.categoryId,
          ),
          search: searchController.text);
      previousSearchQuery = searchController.text;
      sortBy = null;
      setState(() {});
    }
  }

  void _loadMore() async {
    if (controller.isEndReached()) {
      if (context.read<FetchItemFromCategoryCubit>().hasMoreData()) {
        context.read<FetchItemFromCategoryCubit>().fetchItemFromCategoryMore(
            catId: int.parse(
              widget.categoryId,
            ),
            search: searchController.text,
            sortBy: sortBy);
      }
    }
  }

  Widget searchBarWidget() {
    return Container(
      height: 56.rh(context),
      color: context.color.secondaryColor,
      child: LayoutBuilder(builder: (context, c) {
        return SizedBox(
            width: c.maxWidth,
            child: FittedBox(
              fit: BoxFit.none,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 18.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 243.rw(context),
                        height: 40.rh(context),
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: context.color.borderColor.darken(30)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: context.color.primaryColor),
                        child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              //OutlineInputBorder()
                              fillColor:
                                  Theme.of(context).colorScheme.primaryColor,
                              hintText: "searchHintLbl".translate(context),
                              prefixIcon: setSearchIcon(),
                              prefixIconConstraints: const BoxConstraints(
                                  minHeight: 5, minWidth: 5),
                            ),
                            enableSuggestions: true,
                            onEditingComplete: () {
                              setState(
                                () {
                                  isFocused = false;
                                },
                              );
                              FocusScope.of(context).unfocus();
                            },
                            onTap: () {
                              //change prefix icon color to primary
                              setState(() {
                                isFocused = true;
                              });
                            })),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isList = false;
                        });
                      },
                      child: Container(
                        width: 40.rw(context),
                        height: 40.rh(context),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: context.color.borderColor.darken(30)),
                          color: context.color.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: UiUtils.getSvg(AppIcons.gridViewIcon,
                              color: !isList
                                  ? context.color.textDefaultColor
                                  : context.color.textDefaultColor
                                      .withOpacity(0.2)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isList = true;
                        });
                      },
                      child: Container(
                        width: 40.rw(context),
                        height: 40.rh(context),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: context.color.borderColor.darken(30)),
                          color: context.color.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: UiUtils.getSvg(AppIcons.listViewIcon,
                              color: isList
                                  ? context.color.textDefaultColor
                                  : context.color.textDefaultColor
                                      .withOpacity(0.2)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }

  Widget setSearchIcon() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: UiUtils.getSvg(AppIcons.search,
            color: context.color.textDefaultColor));
  }

  Widget setSuffixIcon() {
    return GestureDetector(
      onTap: () {
        searchController.clear();
        isFocused = false; //set icon color to black back
        FocusScope.of(context).unfocus(); //dismiss keyboard
        setState(() {});
      },
      child: Icon(
        Icons.close_rounded,
        color: Theme.of(context).colorScheme.blackColor,
        size: 30,
      ),
    );
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
      child: PopScope(
        canPop: true,
        onPopInvoked: (isPop) {
          Constant.itemFilter = null;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          appBar: UiUtils.buildAppBar(
            context,
            showBackButton: true,
            title: selectedcategoryName == ""
                ? widget.categoryName
                : selectedcategoryName,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Debug log to check if onRefresh is triggered

              searchbody = {};
              Constant.itemFilter = null;

              context.read<FetchItemFromCategoryCubit>().fetchItemFromCategory(
                    categoryId: int.parse(widget.categoryId),
                    search: "",
                  );
            },
            color: context.color.territoryColor,
            child: Column(
              children: [
                searchBarWidget(),
                filterBarWidget(),
                Expanded(
                  child: screenContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView screenContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 10.rw(context)),
      children: [
        sliderAndVendor(),
        fetchItems(),
      ],
    );
  }

  Widget sliderAndVendor() {
    return BlocBuilder<FetchSliderVendorFromCategoryCubit,
        FetchSliderVendorFromCategoryState>(
      builder: (context, state) {
        if (state is FetchSliderVendorFromCategoryInProgress) {
          final HomeSlider s = HomeSlider(image: AppSettings.image);
          final User u = User(profile: AppSettings.image);
          return Skeletonizer(
            enabled: true,
            containersColor: Colors.grey.shade300,
            child: _sliderAndVendors(
              sliderList: [s, s, s],
              vendors: List.generate(10, (i) => u),
            ),
          );
        } else if (state is FetchSliderVendorFromCategorySuccess) {
          return _sliderAndVendors(
            sliderList: state.sliders,
            vendors: state.vendors,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Column _sliderAndVendors({
    required List<HomeSlider> sliderList,
    required List<User> vendors,
  }) {
    return Column(
      children: [
        if (sliderList.isNotEmpty) _SliderWidget(sliderList),
        if (vendors.isNotEmpty)
          Container(
            height: 45.rw(context),
            margin: EdgeInsets.symmetric(vertical: 10.rw(context)),
            alignment: Alignment.center,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vendors.length,
              shrinkWrap: vendors.length < 10,
              itemBuilder: (context, index) {
                final User vendor = vendors[index];
                return Container(
                  width: 45.rw(context),
                  margin: EdgeInsets.symmetric(horizontal: 10.rw(context)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.5),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.sellerDetailsScreen,
                          arguments: {
                            "seller": vendor,
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(12.5),
                      child: UiUtils.getImage(
                        vendor.profile ?? "",
                        height: 45.rw(context),
                        width: 45.rw(context),
                        fit: BoxFit.cover,
                        errorWidget: _firstLetter(vendor.projectName),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Padding? _firstLetter(String? sellerName) {
    if (sellerName == null) return null;
    List<String> list = sellerName.split(" ");
    String name = '';
    for (String e in list) {
      name += e[0].toUpperCase();
    }
    return Padding(
      padding: EdgeInsets.all(10.rw(context)),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(name)
            .color(context.color.territoryColor)
            .bold()
            .size(16.rw(context)),
      ),
    );
  }

  Container filterBarWidget() {
    return Container(
      color: context.color.secondaryColor,
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          filterByWidget(),
          VerticalDivider(
            color: context.color.borderColor.darken(50),
          ),
          // Add a vertical divider here
          sortByWidget(),
        ],
      ),
    );
  }

  Widget filterByWidget() {
    return InkWell(
      child: Row(
        children: [
          UiUtils.getSvg(AppIcons.filterByIcon,
              color: context.color.textDefaultColor),
          const SizedBox(
            width: 7,
          ),
          Text("filterTitle".translate(context))
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.filterScreen, arguments: {
          "update": getFilterValue,
          "from": "itemsList",
          "categoryIds": widget.categoryIds
        }).then((value) {
          if (value == true) {
            ItemFilterModel updatedFilter =
                filter!.copyWith(categoryId: widget.categoryId);
            context.read<FetchItemFromCategoryCubit>().fetchItemFromCategory(
                categoryId: int.parse(
                  widget.categoryId,
                ),
                search: searchController.text.toString(),
                filter: updatedFilter);
          }
          setState(() {});
        });
      },
    );
  }

  getFilterValue(ItemFilterModel model) {
    filter = model;
    setState(() {});
  }

  Widget sortByWidget() {
    return InkWell(
      child: Row(
        children: [
          UiUtils.getSvg(AppIcons.sortByIcon,
              color: context.color.textDefaultColor),
          const SizedBox(
            width: 7,
          ),
          Text("sortBy".translate(context))
        ],
      ),
      onTap: () {
        showSortByBottomSheet();
      },
    );
  }

  showSortByBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: context.color.secondaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: context.color.borderColor,
                    ),
                    height: 6,
                    width: 60,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                child: Text(
                  'sortBy'.translate(context),
                  textAlign: TextAlign.start,
                ).bold(weight: FontWeight.bold).size(context.font.large),
              ),

              const Divider(
                  height: 1), // Add some space between title and options
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text('default'.translate(context)),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<FetchItemFromCategoryCubit>()
                      .fetchItemFromCategory(
                          categoryId: int.parse(
                            widget.categoryId,
                          ),
                          search: searchController.text.toString(),
                          sortBy: null);

                  setState(() {
                    sortBy = null;
                  });

                  // Handle option 1 selection
                },
              ),
              const Divider(height: 1), // Divider between option 1 and option 2
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text('newToOld'.translate(context)),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<FetchItemFromCategoryCubit>()
                      .fetchItemFromCategory(
                          categoryId: int.parse(
                            widget.categoryId,
                          ),
                          search: searchController.text.toString(),
                          sortBy: "new-to-old");
                  setState(() {
                    sortBy = "new-to-old";
                  });
                },
              ),
              const Divider(height: 1), // Divider between option 2 and option 3
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text('oldToNew'.translate(context)),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<FetchItemFromCategoryCubit>()
                      .fetchItemFromCategory(
                          categoryId: int.parse(
                            widget.categoryId,
                          ),
                          search: searchController.text.toString(),
                          sortBy: "old-to-new");
                  setState(() {
                    sortBy = "old-to-new";
                  });
                },
              ),
              const Divider(height: 1), // Divider between option 3 and option 4
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text('priceHighToLow'.translate(context)),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<FetchItemFromCategoryCubit>()
                      .fetchItemFromCategory(
                          categoryId: int.parse(
                            widget.categoryId,
                          ),
                          search: searchController.text.toString(),
                          sortBy: "price-high-to-low");
                  setState(() {
                    sortBy = "price-high-to-low";
                  });
                },
              ),
              const Divider(height: 1), // Divider between option 4 and option 5
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text('priceLowToHigh'.translate(context)),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<FetchItemFromCategoryCubit>()
                      .fetchItemFromCategory(
                          categoryId: int.parse(
                            widget.categoryId,
                          ),
                          search: searchController.text.toString(),
                          sortBy: "price-low-to-high");
                  setState(() {
                    sortBy = "price-low-to-high";
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget fetchItems() {
    return BlocBuilder<FetchItemFromCategoryCubit, FetchItemFromCategoryState>(
        buildWhen: (p, c) =>
            c is FetchItemFromCategoryInProgress ||
            c is FetchItemFromCategorySuccess ||
            c is FetchItemFromCategoryFailure,
        builder: (context, state) {
          if (state is FetchItemFromCategoryInProgress) {
            final List<ItemModel> temp =
                List.generate(20, (i) => ItemModel.empty());
            return Skeletonizer(
              enabled: true,
              containersColor: Colors.grey.shade300,
              child: pageData(temp, false),
            );
          }

          if (state is FetchItemFromCategoryFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          if (state is FetchItemFromCategorySuccess) {
            if (state.itemModel.isEmpty) {
              return Center(
                child: NoDataFound(
                  onTap: () {
                    context
                        .read<FetchItemFromCategoryCubit>()
                        .fetchItemFromCategory(
                            categoryId: int.parse(
                              widget.categoryId,
                            ),
                            search: searchController.text.toString());
                  },
                ),
              );
            }
            return pageData(state.itemModel, state.isLoadingMore);
          }
          return Container();
        });
  }

  Column pageData(List<ItemModel> itemModel, bool isLoading) {
    return Column(
      children: [
        isList
            ? ListView.builder(
                shrinkWrap: true,
                controller: controller,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                itemCount: itemModel.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  ItemModel item = itemModel[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.adDetailsScreen,
                        arguments: {
                          'model': item,
                        },
                      );
                    },
                    child: ItemHorizontalCard(
                      item: item,
                    ),
                  );
                },
              )
            : GridView.builder(
                shrinkWrap: true,
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                        crossAxisCount: context.resValue<int>(
                          inPhone: 2,
                          inTablet: 3,
                          inDesktop: 4,
                        ),
                        height: 300,
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 10),
                itemCount: itemModel.length,
                itemBuilder: (context, index) {
                  ItemModel item = itemModel[index];

                  return Align(
                    child: ItemCard(
                      item: item,
                      width: 190,
                    ),
                  );
                },
              ),
        if (isLoading) UiUtils.progress()
      ],
    );
  }
}

class _SliderWidget extends StatefulWidget {
  const _SliderWidget(this.sliderlist);
  final List<HomeSlider> sliderlist;

  @override
  State<_SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<_SliderWidget>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ValueNotifier<int> _bannerIndex = ValueNotifier(0);
  late Timer _timer;
  int bannersLength = 0;
  late final TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    bannersLength = widget.sliderlist.length;
    _tabController = TabController(length: bannersLength, vsync: this);
    _tabController.addListener(() {
      _timer.cancel();
      _startAutoSlider();
      _bannerIndex.value = _tabController.index;
    });
    _startAutoSlider();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerIndex.dispose();
    _timer.cancel();
    _tabController.removeListener(() {}); // Remove the listener
    _tabController.dispose(); // Dispose the TabController
  }

  void _startAutoSlider() {
    // Set up a timer to automatically change the banner index
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      final int nextPage = _bannerIndex.value + 1;
      if (nextPage < bannersLength) {
        _bannerIndex.value = nextPage;
      } else {
        _bannerIndex.value = 0;
      }

      _tabController.animateTo(
        _bannerIndex.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _bannerIndex.value = 0;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 389 / 194,
          child: TabBarView(
            controller: _tabController,
            children: [
              ...List.generate(
                bannersLength,
                (index) => InkWell(
                  onTap: () async {
                    if (widget.sliderlist[index].thirdPartyLink?.isNotEmpty == true) {
                      await urllauncher.launchUrl(
                          Uri.parse(widget.sliderlist[index].thirdPartyLink!),
                          mode: urllauncher.LaunchMode.externalApplication);
                    } else if (widget.sliderlist[index].modelType!
                        .contains("Category")) {
                      if (widget.sliderlist[index].model!.subCategoriesCount! >
                          0) {
                        Navigator.pushReplacementNamed(context, Routes.subCategoryScreen,
                            arguments: {
                              "categoryList": <CategoryModel>[],
                              "catName": widget.sliderlist[index].model!.name,
                              "catId": widget.sliderlist[index].modelId,
                              "categoryIds": [
                                widget.sliderlist[index].model!.parentCategoryId
                                    .toString(),
                                widget.sliderlist[index].modelId.toString()
                              ]
                            });
                      } else {
                        Navigator.pushReplacementNamed(context, Routes.itemsList,
                            arguments: {
                              'catID':
                                  widget.sliderlist[index].modelId.toString(),
                              'catName': widget.sliderlist[index].model!.name,
                              "categoryIds": [
                                widget.sliderlist[index].modelId.toString()
                              ]
                            });
                      }
                    } else {
                      try {
                        ItemRepository fetch = ItemRepository();

                        Widgets.showLoader(context);

                        DataOutput<ItemModel> dataOutput =
                            await fetch.fetchItemFromItemId(
                                widget.sliderlist[index].modelId!);

                        Future.delayed(
                          Duration.zero,
                          () {
                            Widgets.hideLoder(context);
                            Navigator.pushNamed(context, Routes.adDetailsScreen,
                                arguments: {
                                  "model": dataOutput.modelList[0],
                                });
                          },
                        );
                      } catch (e) {
                        Widgets.hideLoder(context);
                        HelperUtils.showSnackBarMessage(context, e.toString());
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: sidePadding),
                    width: MediaQuery.of(context).size.width - 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: UiUtils.getImage(
                          widget.sliderlist[index].image ?? "",
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 7),
          child: Stack(
            children: [
              Row(
                children: List.generate(
                  bannersLength,
                  (i) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.color.textDefaultColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      // Divider color
                    ),
                  ),
                ),
              ),
              TabBar(
                indicatorWeight: 4,
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
                indicator: UnderlineTabIndicator(
                  borderRadius: BorderRadius.circular(50),
                  borderSide:
                      BorderSide(color: context.color.territoryColor, width: 4),
                ),
                unselectedLabelColor: const Color(0xffCAC8C8).withOpacity(0.65),
                splashBorderRadius: BorderRadius.circular(50),
                onTap: (value) {
                  _tabController.animateTo(
                    value,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                tabs: [
                  for (int i = 0; i < bannersLength; i++)
                    const Tab(height: 5, child: SizedBox.shrink())
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
