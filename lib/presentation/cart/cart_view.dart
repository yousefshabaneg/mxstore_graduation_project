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
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';

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
                                      SubtitleText(
                                          text: "Deliver to", size: 14),
                                      SizedBox(width: 5),
                                      Container(
                                        width: kWidth * 0.4,
                                        child: Text(
                                          AccountCubit.get(context)
                                              .deliveryRegionAndCity(),
                                          style: TextStyle(
                                            color: ColorManager.dark,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            wordSpacing: -1,
                                            letterSpacing: -0.5,
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
                              CartList(),
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
                    if (ShopCubit.get(context).favoritesProducts.isNotEmpty)
                      FavoritesView(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child:
                                FaIcon(FontAwesomeIcons.creditCard, size: 22),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child:
                                FaIcon(FontAwesomeIcons.arrowsRotate, size: 22),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FaIcon(FontAwesomeIcons.circleQuestion,
                                size: 22),
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
                    kGrayDivider(),
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
