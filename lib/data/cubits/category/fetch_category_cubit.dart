// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:eClassify/Utils/helper_utils.dart';
import 'package:eClassify/data/Repositories/category_repository.dart';
import 'package:eClassify/data/model/category_model.dart';
import 'package:eClassify/data/model/data_output.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

abstract class FetchCategoryState {}

class FetchCategoryInitial extends FetchCategoryState {}

class FetchCategoryInProgress extends FetchCategoryState {}

class FetchCategorySuccess extends FetchCategoryState {
  final int total;
  final int page;
  final bool isLoadingMore;
  final bool hasError;
  final List<CategoryModel> categories;

  FetchCategorySuccess({
    required this.total,
    required this.page,
    required this.isLoadingMore,
    required this.hasError,
    required this.categories,
  });

  FetchCategorySuccess copyWith({
    int? total,
    int? page,
    bool? isLoadingMore,
    bool? hasError,
    List<CategoryModel>? categories,
  }) {
    return FetchCategorySuccess(
      total: total ?? this.total,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      ' page': page,
      'isLoadingMore': isLoadingMore,
      'hasError': hasError,
      'categories': categories.map((x) => x.toJson()).toList(),
    };
  }

  factory FetchCategorySuccess.fromMap(Map<String, dynamic> map) {
    return FetchCategorySuccess(
      total: map['total'] as int,
      page: map[' page'] as int,
      isLoadingMore: map['isLoadingMore'] as bool,
      hasError: map['hasError'] as bool,
      categories: List<CategoryModel>.from(
        (map['categories']).map<CategoryModel>(
          (x) => CategoryModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory FetchCategorySuccess.fromJson(String source) =>
      FetchCategorySuccess.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FetchCategorySuccess(total: $total,  page: $page, isLoadingMore: $isLoadingMore, hasError: $hasError, categories: $categories)';
  }
}

class FetchCategoryFailure extends FetchCategoryState {
  final String errorMessage;

  FetchCategoryFailure(this.errorMessage);
}

class FetchCategoryCubit extends Cubit<FetchCategoryState> with HydratedMixin {
  FetchCategoryCubit() : super(FetchCategoryInitial());

  final CategoryRepository _categoryRepository = CategoryRepository();

  Future<void> fetchCategories(
      {bool? forceRefresh, bool? loadWithoutDelay}) async {
    try {
      emit(FetchCategoryInProgress());

      page = 1;

      DataOutput<CategoryModel> categories =
          await _categoryRepository.fetchCategories(page: 1);

      emit(FetchCategorySuccess(
          total: categories.total,
          categories: categories.modelList,
          page: 1,
          hasError: false,
          isLoadingMore: false));
    } catch (e) {
      emit(FetchCategoryFailure(e.toString()));
    }
  }

  List<CategoryModel> getCategories() {
    if (state is FetchCategorySuccess) {
      return (state as FetchCategorySuccess).categories;
    }

    return <CategoryModel>[];
  }

  int page = 1;

  Future<void> fetchCategoriesMore() async {
    try {
      print(
          "response :  : map length is $page");
      if (state is FetchCategorySuccess) {
        if ((state as FetchCategorySuccess).isLoadingMore) {
          return;
        }
        page++;
        emit((state as FetchCategorySuccess).copyWith(isLoadingMore: true));
        DataOutput<CategoryModel> result =
            await _categoryRepository.fetchCategories(
          page: page,
        );

        FetchCategorySuccess categoryState = (state as FetchCategorySuccess);
        categoryState.categories.addAll(result.modelList);
        print(
            "response :  : map length is categoryState.categories ${categoryState.categories.length}");

        List<String> list =
            categoryState.categories.map((e) => e.url!).toList();
        await HelperUtils.precacheSVG(list);

        emit(FetchCategorySuccess(
            isLoadingMore: false,
            hasError: false,
            categories: categoryState.categories,
            page: page,
            total: result.total));
      }
    } catch (e) {
      emit((state as FetchCategorySuccess)
          .copyWith(isLoadingMore: false, hasError: true));
    }
  }

  bool hasMoreData() {
    if (state is FetchCategorySuccess) {
      return (state as FetchCategorySuccess).categories.length <
          (state as FetchCategorySuccess).total;
    }
    return false;
  }

  @override
  FetchCategoryState? fromJson(Map<String, dynamic> json) {
    return null;
  }

  @override
  Map<String, dynamic>? toJson(FetchCategoryState state) {
    return null;
  }
}
