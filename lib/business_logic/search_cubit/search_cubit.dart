import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dio_helper.dart';
import '../../data/models/product_model.dart';
import '../../shared/resources/constants_manager.dart';
import 'search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());
  static SearchCubit get(context) => BlocProvider.of(context);

  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  FocusNode focusSearch = new FocusNode();

  startSearch(context) {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));
    focusSearch.requestFocus();
    isSearching = true;
    emit(StartSearchState());
  }

  void stopSearching() {
    clearSearch();
    isSearching = false;
    emit(StopSearchState());
  }

  void clearSearch() {
    searchController.clear();
    searchedProducts.clear();
    notProductsFound = false;
    emit(ClearSearchedState());
  }

  bool notProductsFound = false;
  List<ProductItemModel> searchedProducts = [];
  void getSearchedProducts(
      {String searchWord = "", int? brandId, int? categoryId}) {
    emit(LoadingSearchedProductsState());
    DioHelper.getData(
      url: ConstantsManager.Products,
      query: {
        "PageSize": 20,
        "Search": searchWord,
        "BrandId": brandId,
        "CategoryId": categoryId
      },
    ).then((json) {
      searchedProducts = ProductsModel.fromJson(json).products!;
      if (searchedProducts.isEmpty) notProductsFound = true;
      emit(SuccessSearchedProductsState());
    }).catchError((error) {
      print('GET Searched Products Products ERROR');
      emit(ErrorSearchedProductsState(error));
      print(error.toString());
    });
  }

  bool isCategorySearching = false;
  TextEditingController searchCategoryController = TextEditingController();
  FocusNode focusCategorySearch = new FocusNode();

  startCategorySearch(context) {
    ModalRoute.of(context)!.addLocalHistoryEntry(
        LocalHistoryEntry(onRemove: stopCategorySearching));
    focusCategorySearch.requestFocus();
    isCategorySearching = true;
    emit(StartSearchState());
  }

  void stopCategorySearching() {
    clearCategorySearch();
    isCategorySearching = false;
    emit(StopSearchState());
  }

  void clearCategorySearch() {
    searchCategoryController.clear();
    searchedCategoryProducts.clear();
    notCategoryFound = false;
    emit(ClearSearchedState());
  }

  bool notCategoryFound = false;
  List<ProductItemModel> searchedCategoryProducts = [];
  void getSearchedCategoryProducts(
      {String searchWord = "", int? brandId, int? categoryId}) {
    emit(LoadingSearchedProductsState());
    DioHelper.getData(
      url: ConstantsManager.Products,
      query: {
        "PageSize": 20,
        "Search": searchWord,
        "BrandId": brandId,
        "CategoryId": categoryId
      },
    ).then((json) {
      searchedCategoryProducts = ProductsModel.fromJson(json).products!;
      if (searchedCategoryProducts.isEmpty) notCategoryFound = true;
      emit(SuccessSearchedProductsState());
    }).catchError((error) {
      print('GET Searched Products Products ERROR');
      emit(ErrorSearchedProductsState(error));
      print(error.toString());
    });
  }
}
