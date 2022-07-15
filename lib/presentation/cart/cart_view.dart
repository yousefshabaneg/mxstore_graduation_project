import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../business_logic/shop_cubit/shop_cubit.dart';
import '../../business_logic/shop_cubit/shop_states.dart';
import '../../shared/constants.dart';
import '../../shared/helpers.dart';
import '../../shared/resources/assets_manager.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/delivery_services_widget.dart';
import '../../shared/widgets/indicators.dart';
import '../../shared/widgets/product_item_widget.dart';
import '../checkout/checkout_view.dart';
import 'cart_items.dart';
import 'favorites_item.dart';

class CartView extends StatelessWidget {
  CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              if (state is ShopLoadingChangeQuantityCartState ||
                  state is ShopLoadingUpdateBasketState ||
                  state is ShopLoadingRemoveFromCartState)
                MyLoadingIndicator(circular: true, color: Colors.amber),
              SafeArea(
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
                                    onTap: () {
                                      ShopCubit.get(context)
                                          .cartProductsIds
                                          .forEach((element) {
                                        print("Product: #$element");
                                      });
                                      tabController.index = 0;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (ShopCubit.get(context).favoritesProducts.isNotEmpty)
                          FavoritesList(),
                        kGrayDivider(),
                        ProductsHorizontalListBuilder(
                          title: "Browse offers",
                          cartProduct: true,
                          products: ShopCubit.get(context).productsInStock(),
                          categoryId: 6,
                        ),
                        kGrayDivider(),
                        DeliveryServices(),
                        kGrayDivider(),
                        if (ShopCubit.get(context).cartProductsIds.isNotEmpty)
                          kVSeparator(factor: 0.08),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
