import 'package:graduation_project/data/models/favorites_model.dart';
import 'package:graduation_project/data/models/identity/user_model.dart';
import 'package:graduation_project/data/models/product_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

// Get Products States
class ShopLoadingProductsState extends ShopStates {}

class ShopSuccessProductsState extends ShopStates {}

class ShopErrorProductsState extends ShopStates {
  final String error;

  ShopErrorProductsState(this.error);
}

// Get Filtered Products States
class ShopLoadingFilteredProductsState extends ShopStates {}

class ShopSuccessFilteredProductsState extends ShopStates {}

class ShopErrorFilteredProductsState extends ShopStates {
  final String error;

  ShopErrorFilteredProductsState(this.error);
}

// Get Offered Products States
class ShopLoadingOfferedProductsState extends ShopStates {}

class ShopSuccessOfferedProductsState extends ShopStates {}

class ShopErrorOfferedProductsState extends ShopStates {
  final String error;

  ShopErrorOfferedProductsState(this.error);
}

// Get Products States
class ShopLoadingSearchedProductsState extends ShopStates {}

class ShopSuccessSearchedProductsState extends ShopStates {}

class ShopErrorSearchedProductsState extends ShopStates {
  final String error;

  ShopErrorSearchedProductsState(this.error);
}

// Get Product Ite States
class ShopLoadingGetProductItemState extends ShopStates {}

class ShopSuccessGetProductItemState extends ShopStates {
  final ProductItemModel product;
  ShopSuccessGetProductItemState({required this.product});
}

class ShopErrorGetProductItemState extends ShopStates {
  final String error;

  ShopErrorGetProductItemState(this.error);
}

class ShopClearSearchedState extends ShopStates {}

// Get Categories States
class ShopLoadingCategoriesState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {
  final String error;

  ShopErrorCategoriesState(this.error);
}

// Get Brands States
class ShopLoadingBrandsState extends ShopStates {}

class ShopSuccessBrandsState extends ShopStates {}

class ShopErrorBrandsState extends ShopStates {
  final String error;

  ShopErrorBrandsState(this.error);
}

// Get Banners States
class ShopLoadingBannersState extends ShopStates {}

class ShopSuccessBannersState extends ShopStates {}

class ShopErrorBannersState extends ShopStates {
  final String error;

  ShopErrorBannersState(this.error);
}

// Get Favorites States
class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

// Get Change Favorites States
class ShopLoadingChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoritesModel changeFavoritesModel;
  ShopSuccessChangeFavoritesState(this.changeFavoritesModel);
}

class ShopErrorChangeFavoritesState extends ShopStates {}

// Add to Cart States
class ShopLoadingAddToCartState extends ShopStates {}

class ShopSuccessAddToCartState extends ShopStates {}

class ShopErrorAddToCartState extends ShopStates {}

// Basket States
class ShopLoadingBasketState extends ShopStates {}

class ShopSuccessBasketState extends ShopStates {}

class ShopErrorBasketState extends ShopStates {}
