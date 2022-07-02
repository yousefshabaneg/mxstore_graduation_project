import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/data/dio_helper.dart';
import 'package:graduation_project/data/models/address_model.dart';
import 'package:graduation_project/data/models/banner_model.dart';
import 'package:graduation_project/data/models/basket_model.dart';
import 'package:graduation_project/data/models/brand_model.dart';
import 'package:graduation_project/data/models/category_model.dart';
import 'package:graduation_project/data/models/comment_model.dart';
import 'package:graduation_project/data/models/delivery_model.dart';
import 'package:graduation_project/data/models/favorites_model.dart';
import 'package:graduation_project/data/models/payment_model.dart';
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

  List<BasketProductModel> cartProducts = [];
  List cartProductsIds = [];
  int cartQuantities = 0;
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

  void getBasket() {
    cartProductsIds.clear();
    cartQuantities = 0;
    emit(ShopLoadingBasketState());
    DioHelper.getData(
        url: "${ConstantsManager.Basket}",
        query: {"id": basketId}).then((json) async {
      ConstantsManager.basketId = json["id"];
      basketModel = BasketModel.fromJson(json);
      cartProducts = basketModel!.products;
      cartProducts.forEach((element) {
        cartProductsIds.add(element.id);
        cartQuantities += element.quantity;
      });
      emit(ShopSuccessBasketState());
    }).catchError((error) {
      errorMessage = error;
      emit(ShopErrorBasketState());
    });
  }

  Future<void> clearBasket() async {
    cartProductsIds.clear();
    cartQuantities = 0;
    basketModel?.products.clear();
    emit(ShopLoadingClearBasketState());
    final newBasket = basketModel?.toJson();
    await DioHelper.postData(
            url: "${ConstantsManager.Basket}", data: newBasket!)
        .then((json) {
      basketModel = BasketModel.fromJson(json);
      emit(ShopSuccessClearBasketState());
    }).catchError((error) {
      errorMessage = error;
      emit(ShopErrorClearBasketState());
    });
  }

  Future<void> addToCart(ProductItemModel product) async {
    if (!cartProducts.any((item) => item.id == product.id)) {
      emit(ShopLoadingAddToCartState(product.id));
      final productToAdd = BasketProductModel.mapProductToBasket(product);
      basketModel?.products.add(productToAdd);
      cartQuantities++;
      final newBasket = basketModel?.toJson();
      if (newBasket != null) {
        await DioHelper.postData(
                url: "${ConstantsManager.Basket}", data: newBasket)
            .then((json) {
          basketModel = BasketModel.fromJson(json);
          cartProducts = basketModel!.products;
          cartProductsIds.add(product.id);
          successMessage = "Product Added to cart";
          emit(ShopSuccessAddToCartState());
        }).catchError((error) {
          basketModel?.products.remove(productToAdd);
          errorMessage = error;
          emit(ShopErrorAddToCartState());
        });
      } else {
        errorMessage = "error occurred, try again later.";
        emit(ShopErrorAddToCartState());
      }
    }
  }

  void changeQuantity(BasketProductModel product, int quantity) {
    emit(ShopLoadingChangeQuantityCartState());
    int oldQuantity = product.quantity;
    cartQuantities -= oldQuantity;
    cartQuantities += quantity;
    basketModel?.products.firstWhere((p) => p.id == product.id).quantity =
        quantity;
    final newBasket = basketModel?.toJson();
    if (newBasket != null) {
      DioHelper.postData(url: "${ConstantsManager.Basket}", data: newBasket)
          .then((json) async {
        basketModel = BasketModel.fromJson(json);
        cartProducts = basketModel!.products;
        emit(ShopSuccessChangeQuantityCartState());
      }).catchError((error) {
        basketModel?.products.firstWhere((p) => p.id == product.id).quantity =
            oldQuantity;
        errorMessage = error;
        emit(ShopErrorChangeQuantityCartState());
      });
    } else {
      errorMessage = "error occurred, try again later.";
      emit(ShopErrorChangeQuantityCartState());
    }
  }

  Future<void> removeFromCart(BasketProductModel product) async {
    emit(ShopLoadingRemoveFromCartState(product.id));
    basketModel?.products.removeWhere((p) => p.id == product.id);
    cartQuantities -= product.quantity;
    final newBasket = basketModel?.toJson();
    if (newBasket != null) {
      cartProductsIds.remove(product.id);
      DioHelper.postData(url: "${ConstantsManager.Basket}", data: newBasket)
          .then((json) async {
        basketModel = BasketModel.fromJson(json);
        cartProducts = basketModel!.products;
        successMessage = "Product Removed from cart";
        emit(ShopSuccessRemoveFromCartState());
      }).catchError((error) {
        basketModel?.products.add(product);
        cartProductsIds.add(product.id);
        errorMessage = error;
        emit(ShopErrorRemoveFromCartState());
      });
    } else {
      errorMessage = "error occurred, try again later.";
      emit(ShopErrorRemoveFromCartState());
    }
  }

  int cartTotalPrice() {
    int sum = 0;
    basketModel?.products.forEach((product) {
      sum += product.quantity * (product.price ?? 0);
    });
    return sum;
  }

  String cartItemQuantity(int? productId) {
    return productId != null
        ? cartProducts
            .firstWhere((element) => element.id == productId)
            .quantity
            .toString()
        : '1';
  }

  bool isProductInCart(int productId) => cartProductsIds.contains(productId);

  List<ProductItemModel> cartProductsInMemory() {
    return products
        .where((product) => favoritesProductsIds.contains(product.id))
        .toList();
  }

  List<DeliveryModel> deliveryMethods = [];
  void getDeliveryMethods() {
    emit(ShopLoadingDeliveryMethodState());
    DioHelper.getData(url: "${ConstantsManager.DeliveryMethod}", token: token)
        .then((json) {
      deliveryMethods =
          List.from(json).map((e) => DeliveryModel.fromJson(e)).toList();
      deliveryMethods.sort((a, b) => a.id!.compareTo(b.id!));
      emit(ShopSuccessDeliveryMethodState());
    }).catchError((error) {
      errorMessage = error;
      print(error);
      emit(ShopErrorDeliveryMethodState());
    });
  }

  List<PaymentModel> paymentMethods = [];
  void getPaymentMethods() {
    emit(ShopLoadingPaymentMethodState());
    DioHelper.getData(url: "${ConstantsManager.PaymentMethod}", token: token)
        .then((json) {
      paymentMethods =
          List.from(json).map((e) => PaymentModel.fromJson(e)).toList();
      paymentMethods.sort((a, b) => a.id!.compareTo(b.id!));
      emit(ShopSuccessPaymentMethodState());
    }).catchError((error) {
      errorMessage = error;
      print(error);
      emit(ShopErrorPaymentMethodState());
    });
  }

  String getPaymentNameById() {
    return paymentMethods
            .firstWhere((element) => element.id == paymentMethodId)
            .name ??
        "Cash on Delivery";
  }

  double getDeliveryPrice() {
    return deliveryMethods
            .firstWhere((element) => element.id == deliveryId)
            .price ??
        0;
  }

  double getPriceWithDelivery() => cartTotalPrice() + getDeliveryPrice();

  int deliveryId = 1;
  void changeDeliveryId(int? value) {
    deliveryId = value ?? 1;
    emit(ShopChangeDeliveryIdState());
  }

  int paymentMethodId = 1;
  void changePaymentMethodId(int? value) {
    paymentMethodId = value ?? 1;
    emit(ShopChangeDeliveryIdState());
  }

  Future<String?> placeOrderCash(AddressModel addressModel) async {
    String? orderId;
    emit(ShopLoadingCreateOrderState());
    print("Basket Id : $basketId");
    await DioHelper.postData(
        url: "${ConstantsManager.Orders}",
        token: token,
        data: {
          "basketId": basketId,
          "deliveryMethodId": deliveryId,
          "paymentMethodId": paymentMethodId,
          "shipToAddress": addressModel.toJson(),
        }).then((json) async {
      await clearBasket();
      print(json);
      orderId = "NEG260161";
      emit(ShopSuccessCreateOrderState());
    }).catchError((error) {
      errorMessage = error;
      print(error);
      emit(ShopErrorCreateOrderState());
    });
    return orderId;
  }

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  final GlobalKey<FormState> cardFormKey = GlobalKey<FormState>();

  void setCardInfo({
    required String cardNumber,
    required String expiryDate,
    required String cardHolderName,
    required String cvvCode,
  }) {
    this.cardNumber = cardNumber;
    this.expiryDate = expiryDate;
    this.cardHolderName = cardHolderName;
    this.cvvCode = cvvCode;
  }

  void payWithCard() {
    print("$cardNumber $expiryDate $cardHolderName $cvvCode");
  }
}
