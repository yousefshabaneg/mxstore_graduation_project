import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../business_logic/shop_cubit/shop_cubit.dart';
import '../../business_logic/shop_cubit/shop_states.dart';
import '../../data/models/product_model.dart';
import '../../shared/constants.dart';
import '../../shared/helpers.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/indicators.dart';
import '../../shared/widgets/product_details_widgets.dart';
import '../products/product_details_view.dart';

class FavoritesList extends StatefulWidget {
  FavoritesList({Key? key}) : super(key: key);

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            kGrayDivider(),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTileTheme(
                  contentPadding: EdgeInsets.zero,
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          "My Wishlist",
                          style: kTheme.textTheme.bodyText1,
                        ),
                        kHSeparator(),
                        CircleAvatar(
                          backgroundColor: ColorManager.lightGray,
                          radius: 12,
                          child: Text(
                            "${ShopCubit.get(context).favoritesProducts.length}",
                            style: kTheme.textTheme.bodyText2!.copyWith(
                              color: ColorManager.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: AnimatedRotation(
                      turns: _isExpanded ? .5 : 0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOutSine,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                        color: ColorManager.primary,
                      ),
                    ),
                    onExpansionChanged: (isExpansion) =>
                        setState(() => _isExpanded = isExpansion),
                    iconColor: Colors.black,
                    children: List.generate(
                        ShopCubit.get(context).favoritesProducts.length,
                        (index) => Column(
                              children: [
                                FavoriteItemWidget(
                                  product: ShopCubit.get(context)
                                      .favoritesProducts[index],
                                ),
                                if (index !=
                                    ShopCubit.get(context)
                                            .favoritesProducts
                                            .length -
                                        1)
                                  kDivider(factor: 0.02, opacity: 0.3),
                              ],
                            )),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FavoriteItemWidget extends StatelessWidget {
  FavoriteItemWidget({Key? key, required this.product}) : super(key: key);
  final ProductItemModel product;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () =>
              push(context, ProductDetailsView(productId: product.id!)),
          child: Row(
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
        ),
        kVSeparator(),
        ProductDetailsHelpers.deliveryTime(),
        kVSeparator(),
        BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, state) {},
          builder: (context, state) => Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConditionalBuilder(
                  condition: product.numberInStock > 0,
                  builder: (context) {
                    return SolidButton(
                      withIcon: true,
                      size: 14,
                      heightFactor: 0.05,
                      widthFactor: 0.4,
                      icon: !ShopCubit.get(context).isProductInCart(product.id!)
                          ? FontAwesomeIcons.cartShopping
                          : FontAwesomeIcons.check,
                      radius: 10,
                      text: !ShopCubit.get(context).isProductInCart(product.id!)
                          ? "Add to cart"
                          : "In Cart",
                      color:
                          !ShopCubit.get(context).isProductInCart(product.id!)
                              ? Colors.white
                              : Colors.black,
                      splashColor: ColorManager.primary,
                      backgroundColor:
                          !ShopCubit.get(context).isProductInCart(product.id!)
                              ? ColorManager.black
                              : Colors.white,
                      borderColor:
                          !ShopCubit.get(context).isProductInCart(product.id!)
                              ? Colors.transparent
                              : ColorManager.dark,
                      child: state is ShopLoadingAddToCartState &&
                              state.id == product.id
                          ? const MyLoadingIndicator(height: 20, width: 30)
                          : null,
                      onTap: () {
                        ShopCubit.get(context).addToCart(product);
                      },
                    );
                  },
                  fallback: (context) => SolidButton(
                    withIcon: true,
                    size: 14,
                    heightFactor: 0.05,
                    widthFactor: 0.4,
                    icon: FontAwesomeIcons.cartShopping,
                    radius: 10,
                    text: "out of stock",
                    color: Colors.white,
                    disabledColor: Colors.black38,
                  ),
                ),
                MyTextButton(
                  withIcon: true,
                  icon: FontAwesomeIcons.trash,
                  widthFactor: 0.2,
                  text: "Remove",
                  color: ColorManager.info.withOpacity(0.6),
                  size: 14,
                  heightFactor: 0.04,
                  onTap: () =>
                      ShopCubit.get(context).removeFavoriteProduct(product.id!),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
