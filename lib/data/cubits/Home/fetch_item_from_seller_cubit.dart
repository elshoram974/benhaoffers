import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Repositories/Item/item_repository.dart';
import '../../model/data_output.dart';
import '../../model/item/item_model.dart';

abstract class FetchItemFromSellerState {}

class FetchItemFromSellerInitial extends FetchItemFromSellerState {}

class FetchItemFromSellerInProgress extends FetchItemFromSellerState {}

class FetchItemFromSellerSuccess extends FetchItemFromSellerState {
  final bool isLoadingMore;
  final bool loadingMoreError;
  final List<ItemModel> itemModel;
  final int page;
  final int total;
  final int? sellerId;

  FetchItemFromSellerSuccess(
      {required this.isLoadingMore,
      required this.loadingMoreError,
      required this.itemModel,
      required this.page,
      required this.total,
      this.sellerId});

  FetchItemFromSellerSuccess copyWith(
      {bool? isLoadingMore,
      bool? loadingMoreError,
      List<ItemModel>? itemModel,
      int? page,
      int? total,
      int? sellerId}) {
    return FetchItemFromSellerSuccess(
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadingMoreError: loadingMoreError ?? this.loadingMoreError,
        itemModel: itemModel ?? this.itemModel,
        page: page ?? this.page,
        total: total ?? this.total,
        sellerId: sellerId ?? this.sellerId);
  }
}

class FetchItemFromSellerFailure extends FetchItemFromSellerState {
  final String errorMessage;

  FetchItemFromSellerFailure(this.errorMessage);
}

class FetchItemFromSellerCubit extends Cubit<FetchItemFromSellerState> {
  FetchItemFromSellerCubit() : super(FetchItemFromSellerInitial());

  final ItemRepository _itemRepository = ItemRepository();

  Future<void> fetchItemFromSeller({required int sellerId}) async {
    try {
      emit(FetchItemFromSellerInProgress());

      DataOutput<ItemModel> result = await _itemRepository
          .fetchItemFromSellerId(sellerId: sellerId, page: 1);
      emit(
        FetchItemFromSellerSuccess(
          isLoadingMore: false,
          loadingMoreError: false,
          itemModel: result.modelList,
          page: 1,
          total: result.total,
          sellerId: sellerId,
        ),
      );
    } catch (e) {
      emit(FetchItemFromSellerFailure(e.toString()));
    }
  }

  Future<void> fetchItemFromSellerMore({required int sellerId}) async {
    try {
      if (state is FetchItemFromSellerSuccess) {
        if ((state as FetchItemFromSellerSuccess).isLoadingMore) {
          return;
        }
        emit((state as FetchItemFromSellerSuccess)
            .copyWith(isLoadingMore: true));

        DataOutput<ItemModel> result = await _itemRepository.fetchItemFromSellerId(
          sellerId: sellerId,
          page: (state as FetchItemFromSellerSuccess).page + 1,
        );

        FetchItemFromSellerSuccess item = (state as FetchItemFromSellerSuccess);

        item.itemModel.addAll(result.modelList);

        emit(
          FetchItemFromSellerSuccess(
            isLoadingMore: false,
            loadingMoreError: false,
            itemModel: item.itemModel,
            page: (state as FetchItemFromSellerSuccess).page + 1,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as FetchItemFromSellerSuccess).copyWith(
          isLoadingMore: false,
          loadingMoreError: true,
        ),
      );
    }
  }

  bool hasMoreData() {
    if (state is FetchItemFromSellerSuccess) {
      return (state as FetchItemFromSellerSuccess).itemModel.length <
          (state as FetchItemFromSellerSuccess).total;
    }
    return false;
  }
}
