import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../data/dio_helper.dart';
import '../../data/models/address_model.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/basket_model.dart';
import '../../data/models/brand_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/delivery_model.dart';
import '../../data/models/favorites_model.dart';
import '../../data/models/identity/user_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/product_model.dart';
import '../../shared/constants.dart';
import '../../shared/helpers.dart';
import '../../shared/resources/constants_manager.dart';
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
  List<ProductItemModel> allProducts = [];
  late ProductsModel allProductsModel;
  List<ProductItemModel> offeredProducts = [];
  List<ProductItemModel> products = [];
  late ProductsModel productsModel;

  List favoritesProductsIds = [];
  List<ProductItemModel> favoritesProducts = [];

  List<BasketProductModel> cartProducts = [];
  List cartProductsIds = [];
  int cartQuantities = 0;
  BasketModel? basketModel;

  ChangeFavoritesModel? changeFavoritesModel;

  Future<void>? getEverything() async {
    if (products.isEmpty &&
        categories.isEmpty &&
        banners.isEmpty &&
        brands.isEmpty) {
      getCategories();
      getBrands();
      getBanners();
      getAllProducts();
      getProducts();
      getOfferedProducts();
    }
  }

  bool everythingIsLoaded() =>
      categories.isNotEmpty &&
      brands.isNotEmpty &&
      products.isNotEmpty &&
      offeredProducts.isNotEmpty;

  Future<void> logout(context) async {
    emit(ShopLoadingLogoutState());
    await signOut(context);
    favoritesProductsIds.clear();
    favoritesProducts.clear();
    cartProductsIds.clear();
    cartQuantities = 0;
    basketModel = null;
    cartProducts.clear();
    deliveryId = 1;
    paymentMethodId = 1;
    userOrders.clear();
    emit(ShopSuccessLogoutState());
  }

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

  void getAllProducts() {
    emit(ShopLoadingAllProductsState());
    DioHelper.getData(url: ConstantsManager.Products, query: {"PageSize": 100})
        .then((json) {
      allProductsModel = ProductsModel.fromJson(json);
      allProducts = allProductsModel.products!;
      emit(ShopSuccessAllProductsState());
    }).catchError((error) {
      print('GET All Products ERROR');
      emit(ShopErrorAllProductsState(error));
      print(error.toString());
    });
  }

  List<ProductItemModel> similarBrand(
      {required int productId, required int brandId}) {
    return allProducts
        .where(
            (element) => element.id != productId && element.brandId == brandId)
        .toList();
  }

  List<ProductItemModel> similarCategory(
      {required int productId, required int categoryId}) {
    return allProducts
        .where((element) =>
            element.id != productId && element.categoryId == categoryId)
        .toList();
  }

  List<ProductItemModel> productsInStock() {
    return allProducts
        .where((element) => element.numberInStock > 0)
        .take(20)
        .toList();
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
        productModel!.reviews = productModel!.comments.length;
        productModel!.comments.sort((b, a) => a.date!.compareTo(b.date!));
        productModel!.comments.forEach((element) {
          print(element.date ?? "");
        });
        productModel!.comments.forEach((element) {
          int rating = element.rating?.toInt() ?? 0;
          if (productModel!.ratingPercent[rating] != null) {
            productModel!.ratingPercent[rating] =
                productModel!.ratingPercent[rating]! + 1;
          }
        });
        productModel!.comments = productModel!.comments
            .where((element) => element.comment!.isNotEmpty)
            .toList();
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
    cartProducts.clear();
    emit(ShopLoadingBasketState());
    DioHelper.getData(
        url: "${ConstantsManager.Basket}",
        query: {"id": basketId}).then((json) async {
      ConstantsManager.basketId = json["id"];
      basketModel = BasketModel.fromJson(json);
      cartProducts = basketModel!.products;
      List cartIds = [];
      int quantities = 0;
      cartProducts.forEach((element) {
        cartProductsIds.add(element.id);
        cartIds.add(element.id);
        cartQuantities += element.quantity;
        quantities += element.quantity;
      });
      cartProductsIds.addAll(cartIds);
      cartQuantities = quantities;
      emit(ShopSuccessBasketState());
    }).catchError((error) {
      errorMessage = error;
      emit(ShopErrorBasketState());
    });
  }

  Future<void> clearBasket() async {
    cartProductsIds.clear();
    cartQuantities = 0;
    cartProducts.clear();
    basketModel?.products.clear();
    basketModel?.clientSecret = null;
    basketModel?.paymentIntentId = null;

    emit(ShopLoadingClearBasketState());
    final resetBasket = basketModel?.toJson();
    await DioHelper.postData(
            url: "${ConstantsManager.Basket}", data: resetBasket!)
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
      final oldBasket = basketModel?.copyWith();
      oldBasket?.products.add(productToAdd);
      final newBasket = oldBasket?.toJson();
      if (newBasket != null) {
        await DioHelper.postData(
                url: "${ConstantsManager.Basket}", data: newBasket)
            .then((json) {
          basketModel = BasketModel.fromJson(json);
          cartProducts = basketModel!.products;
          cartProductsIds.add(product.id);
          cartQuantities++;
          successMessage = "Product Added to cart";
          emit(ShopSuccessAddToCartState());
        }).catchError((error) {
          errorMessage = error;
          emit(ShopErrorAddToCartState());
        });
      } else {
        errorMessage = "error occurred, try again later.";
        emit(ShopErrorAddToCartState());
      }
    }
  }

  Future<void> updateBasket() async {
    emit(ShopLoadingUpdateBasketState());
    basketModel?.deliveryMethodId = deliveryId;
    final oldBasket = basketModel?.copyWith();
    final newBasket = oldBasket?.toJson();
    if (newBasket != null) {
      await DioHelper.postData(
              url: "${ConstantsManager.Basket}", data: newBasket)
          .then((json) {
        basketModel = BasketModel.fromJson(json);
        emit(ShopSuccessUpdateBasketState());
      }).catchError((error) {
        errorMessage = error;
        emit(ShopErrorUpdateBasketState());
      });
    } else {
      errorMessage = "error occurred, try again later.";
      emit(ShopErrorAddToCartState());
    }
  }

  void changeQuantity(BasketProductModel product, int quantity) {
    emit(ShopLoadingChangeQuantityCartState());
    int oldQuantity = product.quantity;
    final oldBasket = basketModel?.copyWith();
    oldBasket?.products.firstWhere((p) => p.id == product.id).quantity =
        quantity;
    final newBasket = oldBasket?.toJson();
    if (newBasket != null) {
      DioHelper.postData(url: "${ConstantsManager.Basket}", data: newBasket)
          .then((json) async {
        basketModel = BasketModel.fromJson(json);
        cartProducts = basketModel!.products;
        cartQuantities -= oldQuantity;
        cartQuantities += quantity;
        emit(ShopSuccessChangeQuantityCartState());
      }).catchError((error) {
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
    final oldBasket = basketModel?.copyWith();
    oldBasket?.products.removeWhere((p) => p.id == product.id);
    final newBasket = oldBasket?.toJson();
    if (newBasket != null) {
      DioHelper.postData(url: "${ConstantsManager.Basket}", data: newBasket)
          .then((json) async {
        basketModel = BasketModel.fromJson(json);
        cartProductsIds.removeWhere((id) => id == product.id);
        cartQuantities -= product.quantity;
        cartProducts = basketModel!.products;
        successMessage = "Product Removed from cart";
        emit(ShopSuccessRemoveFromCartState());
      }).catchError((error) {
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
        ? basketModel!.products
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

  Future<OrderModel?> createOrder(AddressModel addressModel) async {
    emit(ShopLoadingCreateOrderState());
    OrderModel? createOrderModel;
    await DioHelper.postData(
        url: "${ConstantsManager.Orders}",
        token: token,
        data: {
          "basketId": basketId,
          "deliveryMethodId": deliveryId,
          "paymentMethodId": paymentMethodId,
          "shipToAddress": addressModel.toJson(),
        }).then((json) async {
      createOrderModel = OrderModel.fromJson(json);
      successMessage = "Order Created Successfully";
      emit(ShopSuccessCreateOrderState());
    }).catchError((error) {
      errorMessage = "Error while creating your order";
      print(error);
      emit(ShopErrorCreateOrderState());
    });
    return createOrderModel;
  }

  Future<OrderModel?> placeOrderCash(AddressModel addressModel) async {
    await updateBasket();
    OrderModel? createOrderModel;
    emit(ShopLoadingPaymentCashState());
    await createOrder(addressModel).then((value) {
      if (value != null) {
        print("Pay With Cash Success");
        createOrderModel = value;
        emit(ShopSuccessPaymentCashState());
        clearBasket();
        getUserOrders();
      } else {
        emit(ShopErrorPaymentCashState());
      }
    }).catchError((error) {
      print(error);
      emit(ShopErrorPaymentCashState());
    });
    return createOrderModel;
  }

  Future<OrderModel?> initPayment(
      UserModel userModel, AddressModel addressModel) async {
    await updateBasket();
    OrderModel? createOrderModel;
    emit(ShopLoadingPaymentIntentState());
    await DioHelper.postData(
            url: "${ConstantsManager.Payment}$basketId", token: token)
        .then((json) async {
      basketModel = BasketModel.fromJson(json);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: basketModel!.clientSecret,
        testEnv: true,
        merchantDisplayName: "Ecommerce",
        merchantCountryCode: "US",
      ));
      await Stripe.instance.presentPaymentSheet().then((value) async {
        print("Payment Success value: ");
        createOrderModel = await createOrder(addressModel);
        emit(ShopSuccessPaymentIntentState());
        clearBasket();
        getUserOrders();
      }).catchError(
        (error) {
          print("Error Payment Stripe $error");
          emit(ShopErrorPaymentIntentState());
        },
      );
    }).catchError((error) {
      errorMessage = error;
      print(error);
      emit(ShopErrorPaymentIntentState());
    });
    return createOrderModel;
  }

  List<OrderModel> userOrders = [];
  Future<void> getUserOrders() async {
    emit(ShopLoadingGetOrdersState());
    await DioHelper.getData(url: ConstantsManager.Orders, token: token)
        .then((json) {
      userOrders = List.from(json).map((e) => OrderModel.fromJson(e)).toList();
      userOrders.sort((a, b) => b.id!.compareTo(a.id!));
      emit(ShopSuccessGetOrdersState());
    }).catchError((error) {
      print('GET Orders ERROR');
      emit(ShopErrorGetOrdersState(error));
      print(error.toString());
    });
  }

  Future<void> cancelOrder(OrderModel orderModel) async {
    if (orderModel.orderStatus != OrderStatus.cancelled) {
      emit(ShopLoadingCancelOrderState());
      await DioHelper.getData(
              url: "${ConstantsManager.CancelOrder}/${orderModel.id}",
              token: token)
          .then((json) async {
        await getUserOrders();
        successMessage = "Order cancelled successfully";
        emit(ShopSuccessCancelOrderState());
      }).catchError((error) {
        print('Cancel Order ERROR');
        errorMessage = "Error occurred while cancellation this order";
        emit(ShopErrorCancelOrderState(error));
        print(error.toString());
      });
    }
  }

  Future<bool> rateProduct({
    required int productId,
    String? commentDescription,
    required String name,
    required int rating,
  }) async {
    bool value = false;
    emit(ShopLoadingRateProductState());
    await DioHelper.postData(
        url: ConstantsManager.PostComment,
        token: token,
        data: {
          "commentDescription": commentDescription,
          "productId": productId,
          "rating": rating,
          "userName": name
        }).then((json) {
      value = true;
      emit(ShopSuccessRateProductState());
    }).catchError((error) {
      errorMessage = error;
      emit(ShopErrorRateProductState(error));
    });
    return value;
  }
}
