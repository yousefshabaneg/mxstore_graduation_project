import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';

class FavoritesView extends StatefulWidget {
  FavoritesView({Key? key}) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
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
                      ),
                    ),
                    onExpansionChanged: (isExpansion) =>
                        setState(() => _isExpanded = isExpansion),
                    iconColor: Colors.black,
                    children: List.generate(
                        ShopCubit.get(context).favoritesProducts.length,
                        (index) => FavoriteItemWidget(
                              product: ShopCubit.get(context)
                                  .favoritesProducts[index],
                            )),
                  ),
                ),
              ),
            ),
            kGrayDivider(),
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
              SolidButton(
                withIcon: true,
                icon: FontAwesomeIcons.cartShopping,
                text: "Move to cart",
                color: ColorManager.white,
                size: 14,
                heightFactor: 0.05,
                widthFactor: 0.4,
                backgroundColor: ColorManager.black,
                radius: 10,
                onTap: () => print("add"),
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
        kDivider(factor: 0.02, opacity: 0.3),
      ],
    );
  }
}
