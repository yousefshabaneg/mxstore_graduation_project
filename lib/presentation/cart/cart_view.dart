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
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/presentation/account/address_view.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';

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
                          condition: ShopCubit.get(context).basketModel != null,
                          builder: (context) => Column(
                            children: [
                              BlocConsumer<AccountCubit, AccountStates>(
                                listener: (context, state) {},
                                builder: (context, state) => InkWell(
                                  onTap: () => showEditInfoSheet(
                                    context,
                                    child: AddressView(
                                        user: UserCubit.get(context).userModel),
                                  ),
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.locationDot,
                                        size: 15,
                                        color: ColorManager.subtitle,
                                      ),
                                      SizedBox(width: 10),
                                      SubtitleText(text: "Deliver to"),
                                      SizedBox(width: 5),
                                      Container(
                                        width: kWidth * 0.6,
                                        child: Text(
                                          AccountCubit.get(context)
                                              .deliveryRegionAndCity(),
                                          style: TextStyle(
                                            color: ColorManager.dark,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      FaIcon(FontAwesomeIcons.caretDown,
                                          size: 15)
                                    ],
                                  ),
                                ),
                              ),
                              kDivider(),
                              FavoriteItemWidget(
                                product: ShopCubit.get(context).cartProduct!,
                              ),
                            ],
                          ),
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
                                Container(
                                  width: kWidth * 0.9,
                                  child: SolidButton(
                                    withIcon: true,
                                    icon: FontAwesomeIcons.cartShopping,
                                    radius: 10,
                                    text: "Start Shopping",
                                    heightFactor: 0.07,
                                    backgroundColor: Colors.white,
                                    color: ColorManager.primary,
                                    borderColor: ColorManager.primary,
                                    onTap: () => tabController.index = 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        fallback: (context) => MyLoadingIndicator(),
                      ),
                    ),
                    kVSeparator(factor: 0.05),
                    if (ShopCubit.get(context).favoritesProducts.isNotEmpty)
                      FavoritesView(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FavoritesView extends StatelessWidget {
  FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BodyText(
                      text: "My Wishlist",
                      color: ColorManager.dark,
                      size: 18,
                    ),
                    SubtitleText(
                      text: " (${ShopCubit.get(context).favoritesProducts.length} item" +
                          "${ShopCubit.get(context).favoritesProducts.length > 1 ? "s" : ""}" +
                          ")",
                      size: 14,
                    ),
                  ],
                ),
                kVSeparator(factor: 0.03),
                Column(
                  children: List.generate(
                      ShopCubit.get(context).favoritesProducts.length,
                      (index) => FavoriteItemWidget(
                            product:
                                ShopCubit.get(context).favoritesProducts[index],
                          )),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class FavoriteItemWidget extends StatelessWidget {
  FavoriteItemWidget({Key? key, required this.product}) : super(key: key);
  ProductItemModel product;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: kWidth * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubtitleText(
                    text: product.brandName!,
                    color: ColorManager.subtitle,
                    size: 14,
                  ),
                  SizedBox(height: 5),
                  BodyText(
                    text: product.name!,
                    color: ColorManager.dark,
                    size: 14,
                  ),
                  SizedBox(height: 5),
                  if (product.discount != 0)
                    Text(
                      "EGP ${formatPrice(product.oldPrice!)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorManager.subtitle,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  SizedBox(height: 5),
                  Text(
                    "EGP ${formatPrice(product.price!)}",
                    style: TextStyle(
                      fontSize: 20,
                      color: ColorManager.dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Image(
              image: NetworkImage(product.imageUrl!),
              width: kWidth * 0.25,
              height: kHeight * 0.1,
            ),
          ],
        ),
        kVSeparator(),
        ProductDetailsHelpers.deliveryTime(),
        kVSeparator(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyTextButton(
                withIcon: true,
                icon: FontAwesomeIcons.cartShopping,
                text: "Move to cart",
                color: ColorManager.subtitle.withOpacity(0.6),
                size: 16,
                heightFactor: 0.04,
                onTap: () => print("add"),
              ),
              MyTextButton(
                withIcon: true,
                icon: FontAwesomeIcons.trash,
                widthFactor: 0.2,
                text: "Remove",
                color: ColorManager.subtitle.withOpacity(0.6),
                size: 16,
                heightFactor: 0.04,
                onTap: () =>
                    ShopCubit.get(context).removeFavoriteProduct(product.id!),
              ),
            ],
          ),
        ),
        kDivider(factor: 0.02, opacity: 0.3),
      ],
    );
  }
}
