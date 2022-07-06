import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/account_cubit/account_states.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/presentation/account/address_view.dart';
import 'package:graduation_project/presentation/cart/cart_items.dart';
import 'package:graduation_project/presentation/cart/favorites_item.dart';
import 'package:graduation_project/presentation/checkout/checkout_view.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/product_item_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CartView extends StatelessWidget {
  CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: kHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ConditionalBuilder(
                        condition: state is! ShopLoadingBasketState ||
                            state is! ShopLoadingAddToCartState,
                        builder: (context) => ConditionalBuilder(
                          condition: ShopCubit.get(context).basketModel !=
                                  null &&
                              ShopCubit.get(context).cartProducts.isNotEmpty,
                          builder: (context) => CartList(),
                          fallback: (context) => Center(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  ImageAssets.emptyCart,
                                  width: kWidth * 0.2,
                                  height: kHeight * 0.2,
                                ),
                                kVSeparator(),
                                BodyText(
                                    text: "Your cart is empty!",
                                    size: 24,
                                    align: TextAlign.center,
                                    color: ColorManager.black),
                                kVSeparator(factor: 0.01),
                                Container(
                                  width: kWidth * 0.7,
                                  child: SubtitleText(
                                    text:
                                        "it's the perfect time to start shopping",
                                    color: ColorManager.subtitle,
                                    align: TextAlign.center,
                                  ),
                                ),
                                kVSeparator(),
                                SolidButton(
                                  radius: 10,
                                  text: "Start Shopping",
                                  heightFactor: 0.07,
                                  backgroundColor: Colors.white,
                                  color: ColorManager.black,
                                  widthFactor: 0.9,
                                  borderColor: ColorManager.black,
                                  onTap: () => tabController.index = 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        fallback: (context) => const MyLoadingIndicator(
                            indicatorType: Indicator.ballSpinFadeLoader),
                      ),
                    ),
                    if (ShopCubit.get(context).favoritesProducts.isNotEmpty)
                      FavoritesList(),
                    kGrayDivider(),
                    if (ShopCubit.get(context).cartProducts.isEmpty) ...[
                      ProductsHorizontalListBuilder(
                        title: "Browse offers",
                        cartProduct: true,
                        products: ShopCubit.get(context).products,
                        categoryId: 6,
                      ),
                      kGrayDivider(),
                    ],
                    DeliveryServices(),
                    kGrayDivider(),
                    if (ShopCubit.get(context).cartProductsIds.isNotEmpty)
                      kVSeparator(factor: 0.08),
                  ],
                ),
              ),
            ),
          ),
          bottomSheet: ShopCubit.get(context).basketModel != null &&
                  ShopCubit.get(context).cartProducts.isNotEmpty
              ? Container(
                  height: kHeight * 0.1,
                  width: kWidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(
                              color: ColorManager.gray.withOpacity(0.5),
                              width: 6))),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubtitleText(
                              text:
                                  "Subtotal for ${ShopCubit.get(context).cartQuantities} products",
                              size: 14,
                              color: Colors.black26,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "EGP  ",
                                    style: kTheme.textTheme.caption!.copyWith(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                  TextSpan(
                                    text: formatPrice(ShopCubit.get(context)
                                        .cartTotalPrice()),
                                    style: kTheme.textTheme.headline3!.copyWith(
                                      color: Colors.black,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SolidButton(
                          radius: 10,
                          text: "Checkout",
                          color: Colors.white,
                          splashColor: ColorManager.primary,
                          heightFactor: 0.06,
                          widthFactor: 0.4,
                          backgroundColor: Colors.black,
                          onTap: () => push(context, CheckoutView()),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class DeliveryServices extends StatelessWidget {
  const DeliveryServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FaIcon(FontAwesomeIcons.creditCard, size: 22),
              ),
              kHSeparator(factor: 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "Pay on delivery",
                    color: ColorManager.black,
                  ),
                  SubtitleText(
                    text: "For all orders",
                    color: ColorManager.black,
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
          color: ColorManager.gray,
          indent: kWidth * 0.1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FaIcon(FontAwesomeIcons.arrowsRotate, size: 22),
              ),
              kHSeparator(factor: 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "Return policy",
                    color: ColorManager.black,
                  ),
                  Container(
                    width: kWidth * 0.8,
                    child: SubtitleText(
                      text:
                          "Most products can be returned within 30 days of delivery",
                      color: ColorManager.black,
                      size: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
          color: ColorManager.gray,
          indent: kWidth * 0.1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FaIcon(FontAwesomeIcons.circleQuestion, size: 22),
              ),
              kHSeparator(factor: 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "Need Help?",
                    color: ColorManager.black,
                  ),
                  SubtitleText(
                    text: "19595",
                    color: ColorManager.info,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
