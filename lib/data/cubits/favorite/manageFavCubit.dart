// ignore_for_file: file_names

// import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repositories/favourites_repository.dart';
import '../../model/item/item_model.dart';

abstract class UpdateFavoriteState extends Equatable{
  @override
  List<Object?> get props => [];
}

class UpdateFavoriteInitial extends UpdateFavoriteState {}

class UpdateFavoriteInProgress extends UpdateFavoriteState {
  final int? itemId;

  UpdateFavoriteInProgress(this.itemId);


  @override
  List<Object?> get props => [itemId];
}

class UpdateFavoriteSuccess extends UpdateFavoriteState {
  final ItemModel item;
  final bool wasProcess; //to check that process of Favorite done or not
  UpdateFavoriteSuccess(this.item, this.wasProcess);
}

class UpdateFavoriteFailure extends UpdateFavoriteState {
  final String errorMessage;

  UpdateFavoriteFailure(this.errorMessage);
}

class UpdateFavoriteCubit extends Cubit<UpdateFavoriteState> {
  final FavoriteRepository favoriteRepository;

  UpdateFavoriteCubit(this.favoriteRepository) : super(UpdateFavoriteInitial());

  void setFavoriteItem({required ItemModel item, required int type}) {
    emit(UpdateFavoriteInProgress(item.id));
    favoriteRepository.manageFavorites(item.id!).then((value) {
      emit(UpdateFavoriteSuccess(item, type == 1 ? true : false));
    }).catchError((e) {
      emit(UpdateFavoriteFailure(e.toString()));
    });
  }
}
