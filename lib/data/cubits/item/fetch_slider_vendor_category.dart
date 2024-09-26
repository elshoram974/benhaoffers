import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repositories/Item/item_repository.dart';
import '../../model/home_slider.dart';
import '../../model/item/item_model.dart';

abstract class FetchSliderVendorFromCategoryState {}

class FetchSliderVendorFromCategoryInitial
    extends FetchSliderVendorFromCategoryState {}

class FetchSliderVendorFromCategoryInProgress
    extends FetchSliderVendorFromCategoryState {}

class FetchSliderVendorFromCategorySuccess
    extends FetchSliderVendorFromCategoryState {
  final List<HomeSlider> sliders;
  final List<User> vendors;

  FetchSliderVendorFromCategorySuccess({
    required this.sliders,
    required this.vendors,
  });
}

class FetchSliderVendorFromCategoryFailure
    extends FetchSliderVendorFromCategoryState {
  final String errorMessage;

  FetchSliderVendorFromCategoryFailure(this.errorMessage);
}

class FetchSliderVendorFromCategoryCubit
    extends Cubit<FetchSliderVendorFromCategoryState> {
  FetchSliderVendorFromCategoryCubit()
      : super(FetchSliderVendorFromCategoryInitial());

  final ItemRepository _itemRepository = ItemRepository();

  Future<void> fetchSliderVendorFromCategory(int categoryId) async {
    try {
      emit(FetchSliderVendorFromCategoryInProgress());

      ({List<HomeSlider> sliders, List<User> vendor}) result =
          await _itemRepository.fetchSliderVendorsFromCatId(categoryId);
      emit(
        FetchSliderVendorFromCategorySuccess(
          sliders: result.sliders,
          vendors: result.vendor,
        ),
      );
    } catch (e) {
      emit(
        FetchSliderVendorFromCategoryFailure(e.toString()),
      );
    }
  }
}
