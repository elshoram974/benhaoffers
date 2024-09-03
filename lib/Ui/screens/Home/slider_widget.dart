/*
import 'dart:async';

import 'package:eClassify/data/Repositories/Item/item_repository.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/routes.dart';

import '../../../data/cubits/slider_cubit.dart';
import '../../../data/helper/widgets.dart';
import '../../../data/model/data_output.dart';

import '../../../utils/Extensions/extensions.dart';
import '../../../utils/helper_utils.dart';
import '../../../utils/responsiveSize.dart';
import '../../../utils/ui_utils.dart';
import 'home_screen.dart';
import 'package:url_launcher/url_launcher.dart' as urllauncher;

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<int> _bannerIndex = ValueNotifier(0);
  int bannersLength = 0;
  late Timer _timer;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_bannerIndex.value < bannersLength - 1) {
        _bannerIndex.value++;
      } else {
        _bannerIndex.value = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _bannerIndex.value,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bannerIndex.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<SliderCubit, SliderState>(
      listener: (context, state) {
        if ((state is SliderFetchFailure && !state.isUserDeactivated) ||
            state is SliderFetchSuccess) {
          // context.read<SliderCubit>().fetchSlider(context);
        }
      },
      builder: (context, SliderState state) {
        if (state is SliderFetchInProgress) {
          return Container();
        }
        if (state is SliderFetchSuccess) {
          if (state.sliderlist.isNotEmpty)
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: sidePadding),
              child: SizedBox(
                height: 170.rh(context),
                child: ListView.builder(
                    itemCount: state.sliderlist.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      return InkWell(
                        onTap: () async {
                          if (state.sliderlist[index].thirdPartyLink != "") {
                            await urllauncher.launchUrl(
                                Uri.parse(
                                    state.sliderlist[index].thirdPartyLink!),
                                mode: LaunchMode.externalApplication);
                          } else {
                            try {
                              ItemRepository fetch = ItemRepository();

                              Widgets.showLoader(context);

                              DataOutput<ItemModel> dataOutput =
                                  await fetch.fetchItemFromItemId(
                                      state.sliderlist[index].itemId!);

                              Future.delayed(
                                Duration.zero,
                                () {
                                  Widgets.hideLoder(context);
                                  Navigator.pushNamed(
                                      context, Routes.adDetailsScreen,
                                      arguments: {
                                        "model": dataOutput.modelList[0],
                                      });
                                },
                              );
                            } catch (e) {
                              Widgets.hideLoder(context);
                              HelperUtils.showSnackBarMessage(context,
                                  "somethingWentWrng".translate(context));
                            }
                          }
                        },
                        child: Container(
                          height: 170.rh(context),
                          clipBehavior: Clip.antiAlias,
                          width: context.screenWidth - (sidePadding * 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                          ),
                          child: UiUtils.getImage(
                              state.sliderlist[index].image ?? "",
                              fit: BoxFit.cover),
                        ),
                      );
                    }),
              ),
            );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
*/

import 'dart:async';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/data/model/home_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/helper_utils.dart';
import '../../../Utils/ui_utils.dart';
import '../../../app/routes.dart';
import '../../../data/Repositories/Item/item_repository.dart';
import '../../../data/cubits/slider_cubit.dart';
import '../../../data/helper/widgets.dart';
import '../../../data/model/category_model.dart';
import '../../../data/model/data_output.dart';
import '../../../data/model/item/item_model.dart';
import 'package:url_launcher/url_launcher.dart' as urllauncher;

import '../home/home_screen.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderCubit, SliderState>(
      builder: (context, state) {
        if (state is SliderFetchSuccess && state.sliderlist.isNotEmpty) {
          return _SliderWidget(state.sliderlist);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
// Import your SliderCubit and other necessary dependencies

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
    _tabController.addListener(() => _bannerIndex.value = _tabController.index);
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
    _bannerIndex.value = 0 ;

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
                    if (widget.sliderlist[index].thirdPartyLink != "") {
                      await urllauncher.launchUrl(
                          Uri.parse(widget.sliderlist[index].thirdPartyLink!),
                          mode: LaunchMode.externalApplication);
                    } else if (widget.sliderlist[index].modelType!
                        .contains("Category")) {
                      if (widget.sliderlist[index].model!.subCategoriesCount! >
                          0) {
                        Navigator.pushNamed(context, Routes.subCategoryScreen,
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
                        Navigator.pushNamed(context, Routes.itemsList,
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
