abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class StartSearchState extends SearchStates {}

class StopSearchState extends SearchStates {}

class LoadingSearchedProductsState extends SearchStates {}

class SuccessSearchedProductsState extends SearchStates {}

class ErrorSearchedProductsState extends SearchStates {
  final String error;

  ErrorSearchedProductsState(this.error);
}

class ClearSearchedState extends SearchStates {}
