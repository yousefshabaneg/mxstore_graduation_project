import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/data/dio_helper.dart';
import 'package:graduation_project/data/models/banner_model.dart';
import 'package:graduation_project/data/models/basket_model.dart';
import 'package:graduation_project/data/models/brand_model.dart';
import 'package:graduation_project/data/models/category_model.dart';
import 'package:graduation_project/data/models/comment_model.dart';
import 'package:graduation_project/data/models/favorites_model.dart';
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/resources/constants_manager.dart';
import 'shop_states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);

  String successMessage = "Success";
  String errorMessage = "Error";
  List<CategoryModel> categories = [];
  Map<int, String> brandsMap = {};
  List<BrandModel> brands = [];
  List<BannerModel> banners = [];
  List<ProductItemModel> products = [];
  List<ProductItemModel> offeredProducts = [];
  late ProductsModel productsModel;

  List favoritesProductsIds = [];
  List<ProductItemModel> favoritesProducts = [];

  List cartProductsIds = [];
  ProductItemModel? cartProduct;
  BasketModel? basketModel;

  ChangeFavoritesModel? changeFavoritesModel;

  bool everythingIsLoaded() =>
      categories.isNotEmpty &&
      brands.isNotEmpty &&
      products.isNotEmpty &&
      offeredProducts.isNotEmpty;

  void getCategories() {
    emit(ShopLoadingCategoriesState());
    DioHelper.getData(url: ConstantsManager.Categories).then((json) {
      categories =
          List.from(json).map((e) => CategoryModel.fromJson(e)).toList();
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print('GET Categories ERROR');
      emit(ShopErrorCategoriesState(error));
      print(error.toString());
    });
  }

  void getBrands() {
    emit(ShopLoadingBrandsState());
    DioHelper.getData(url: ConstantsManager.Brands).then((json) {
      brands = List.from(json).map((e) => BrandModel.fromJson(e)).toList();
      brands.forEach((element) {
        brandsMap[element.id] = element.image;
      });
      emit(ShopSuccessBrandsState());
    }).catchError((error) {
      print('GET Brands ERROR');
      emit(ShopErrorBrandsState(error));
      print(error.toString());
    });
  }

  void getBanners() {
    emit(ShopLoadingBannersState());
    DioHelper.getData(url: ConstantsManager.Banners).then((json) {
      banners = List.from(json).map((e) => BannerModel.fromJson(e)).toList();
      emit(ShopSuccessBannersState());
    }).catchError((error) {
      print('GET Banners ERROR');
      emit(ShopErrorBannersState(error));
      print(error.toString());
    });
  }

  void getProducts() {
    emit(ShopLoadingProductsState());
    DioHelper.getData(url: ConstantsManager.Products, query: {"PageSize": 10})
        .then((json) {
      productsModel = ProductsModel.fromJson(json);
      products = productsModel.products!;
      emit(ShopSuccessProductsState());
    }).catchError((error) {
      print('GET Products ERROR');
      emit(ShopErrorProductsState(error));
      print(error.toString());
    });
  }

  Future<List<ProductItemModel>> getOfferedProducts({
    int? brandId,
    int? categoryId,
    int pageSize = 10,
    int pageIndex = 1,
  }) async {
    List<ProductItemModel> offeredProduct = [];
    emit(ShopLoadingOfferedProductsState());
    await DioHelper.getData(url: ConstantsManager.Offers, query: {
      "PageSize": pageSize,
      "PageIndex": pageIndex,
      "BrandId": brandId,
      "CategoryId": categoryId,
    }).then((json) {
      offeredProduct = ProductsModel.fromJson(json).products!;
      offeredProducts = offeredProduct;
      emit(ShopSuccessOfferedProductsState());
    }).catchError((error) {
      print('GET Products Offers ERROR');
      emit(ShopErrorOfferedProductsState(error));
      print(error.toString());
    });
    return offeredProduct;
  }

  Future<List<ProductItemModel>> getFilteredProducts({
    int? brandId,
    int? categoryId,
    int pageSize = 10,
    int pageIndex = 1,
  }) async {
    List<ProductItemModel> filteredProducts = [];
    emit(ShopLoadingFilteredProductsState());
    await DioHelper.getData(url: ConstantsManager.Products, query: {
      "PageSize": pageSize,
      "PageIndex": pageIndex,
      "BrandId": brandId,
      "CategoryId": categoryId,
    }).then((json) {
      filteredProducts = ProductsModel.fromJson(json).products!;
      emit(ShopSuccessFilteredProductsState());
    }).catchError((error) {
      print('GET Products ERROR');
      emit(ShopErrorFilteredProductsState(error));
      print(error.toString());
    });
    return filteredProducts;
  }

  Future<ProductItemModel?> getProduct(int productId) async {
    ProductItemModel? productModel;
    emit(ShopLoadingGetProductItemState());
    await DioHelper.getData(
            url: ConstantsManager.Products + productId.toString())
        .then((json) {
      productModel = ProductItemModel.fromJson(json);
    }).then((value) async {
      await DioHelper.getData(
              url: ConstantsManager.GetComment + productId.toString())
          .then((comments) {
        productModel!.comments = List.from(
            comments.map((comment) => CommentModel.fromJson(comment)));
        emit(ShopSuccessGetProductItemState(product: productModel!));
      });
    }).catchError((error) {
      print('GET Product Item ERROR');
      emit(ShopErrorGetProductItemState(error));
      print(error.toString());
    });
    return productModel;
  }

  void getFavorites() {
    favoritesProductsIds.clear();
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(url: ConstantsManager.Favorites, token: token)
        .then((json) {
      var favoritesData = List.from(json["data"])
          .map((product) => ProductItemModel.fromJson(product))
          .toList();
      favoritesData.forEach((product) {
        favoritesProductsIds.add(product.id);
      });
      favoritesProducts = favoritesData;
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print("Error Favorites $error");
      emit(ShopErrorGetFavoritesState());
    });
  }

  void changeFavorites(int productId) {
    favoritesProductsIds.contains(productId)
        ? favoritesProductsIds.remove(productId)
        : favoritesProductsIds.add(productId); //
    emit(ShopLoadingChangeFavoritesState());
    DioHelper.postData(
        url: "${ConstantsManager.Favorites}",
        token: token,
        data: {"id": productId}).then((json) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(json);
      print(changeFavoritesModel!.status!);
      changeFavoritesModel!.status!
          ? favoritesProducts.add(changeFavoritesModel!.product!)
          : favoritesProducts.removeWhere((e) => e.id == productId);
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favoritesProductsIds.contains(productId)
          ? favoritesProductsIds.remove(productId)
          : favoritesProductsIds.add(productId);
      errorMessage = error;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  void removeFavoriteProduct(int productId) {
    favoritesProductsIds.remove(productId);
    favoritesProducts.removeWhere((e) => e.id == productId);
    emit(ShopLoadingChangeFavoritesState());
    DioHelper.postData(
        url: "${ConstantsManager.Favorites}",
        token: token,
        data: {"id": productId}).then((json) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(json);
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favoritesProductsIds.add(productId);
      errorMessage = error;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  List<ProductItemModel> favoritesProductsInMemory() {
    return products
        .where((product) => favoritesProductsIds.contains(product.id))
        .toList();
  }

  void getBasket(String basketName) {
    emit(ShopLoadingBasketState());
    DioHelper.getData(
        url: "${ConstantsManager.Basket}",
        query: {"id": basketName}).then((json) async {
      ConstantsManager.basketId = json["id"];
      basketModel = BasketModel.fromJson(json);
      cartProduct = await getProduct(basketModel!.products[0].id!);
      emit(ShopSuccessBasketState());
    }).catchError((error) {
      errorMessage = error;
      emit(ShopErrorBasketState());
    });
  }

  void addToCart(ProductItemModel product) {
    cartProductsIds.add(product.id);
    emit(ShopLoadingAddToCartState());
    DioHelper.postData(url: "${ConstantsManager.Basket}", data: {
      "id": "yousefBasket",
      "items": [
        {
          "id": product.id,
          "productName": product.name,
          "price": product.price,
          "quantity": 1,
          "pictureUrl": product.imageUrl!.replaceFirst("10.0.2.2", "localhost"),
          "brand": product.brandName,
          "type": product.typeName,
          "catgeory": product.categoryName
        },
      ],
      "deliveryMethodId": 1,
      "shippingPrice": 0
    }).then((json) async {
      basketModel = BasketModel.fromJson(json);
      cartProduct = await getProduct(product.id!);
      emit(ShopSuccessAddToCartState());
    }).catchError((error) {
      errorMessage = error;
      emit(ShopErrorAddToCartState());
    });
  }

  List<ProductItemModel> cartProductsInMemory() {
    return products
        .where((product) => favoritesProductsIds.contains(product.id))
        .toList();
  }
}
