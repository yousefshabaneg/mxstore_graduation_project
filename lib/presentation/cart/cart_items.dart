import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/basket_model.dart';
import 'package:graduation_project/presentation/products/product_details_view.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CartList extends StatelessWidget {
  CartList({Key? key}) : super(key: key);

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
                      text: "My Cart",
                      color: ColorManager.dark,
                      size: 18,
                    ),
                    kHSeparator(),
                    CircleAvatar(
                      backgroundColor: ColorManager.lightGray,
                      radius: 12,
                      child: Text(
                        "${ShopCubit.get(context).cartQuantities}",
                        style: kTheme.textTheme.bodyText2!.copyWith(
                          color: ColorManager.black,
                        ),
                      ),
                    ),
                  ],
                ),
                kVSeparator(factor: 0.03),
                ...List.generate(
                    ShopCubit.get(context).cartProducts.length,
                    (index) => Column(
                          children: [
                            CartItemWidget(
                              product:
                                  ShopCubit.get(context).cartProducts[index],
                            ),
                            if (index !=
                                ShopCubit.get(context).cartProducts.length - 1)
                              kDivider(factor: 0.02, opacity: 0.3),
                          ],
                        )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CartItemWidget extends StatefulWidget {
  CartItemWidget({Key? key, required this.product}) : super(key: key);
  final BasketProductModel product;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  List<String> items = ['1', '2', '3', '4', '5'];
  String? selectedItem = '1';
  @override
  void initState() {
    super.initState();
    selectedItem = widget.product.quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () =>
              push(context, ProductDetailsView(productId: widget.product.id!)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: kWidth * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubtitleText(
                      text: widget.product.brandName!,
                      color: ColorManager.subtitle,
                      size: 14,
                    ),
                    SizedBox(height: 5),
                    BodyText(
                      text: widget.product.name!,
                      color: ColorManager.dark,
                      size: 14,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "EGP ${formatPrice(widget.product.price!)}",
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
                image: NetworkImage(widget.product.imageUrl!),
                width: kWidth * 0.25,
                height: kHeight * 0.1,
              ),
            ],
          ),
        ),
        kVSeparator(),
        ProductDetailsHelpers.deliveryTime(),
        kVSeparator(factor: .03),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDropdownButton2(
                hint: 'Select Item',
                dropdownItems: items,
                value:
                    ShopCubit.get(context).cartItemQuantity(widget.product.id),
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                  ShopCubit.get(context)
                      .changeQuantity(widget.product, int.parse(value ?? '1'));
                },
                buttonHeight: 30,
                buttonWidth: kWidth * 0.20,
                itemHeight: 30,
                iconSize: 15,
                icon: FaIcon(FontAwesomeIcons.chevronDown),
                dropdownWidth: kWidth * 0.20,
              ),
              Row(
                children: [
                  MyTextButton(
                    withIcon: true,
                    icon: FontAwesomeIcons.heart,
                    text: "Save for later",
                    color: ColorManager.info.withOpacity(0.6),
                    size: 16,
                    heightFactor: 0.04,
                    onTap: () {
                      ShopCubit.get(context).removeFromCart(widget.product);
                      if (!ShopCubit.get(context)
                          .favoritesProductsIds
                          .contains(widget.product.id!)) {
                        ShopCubit.get(context)
                            .changeFavorites(widget.product.id!);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      height: 30,
                      child: VerticalDivider(
                        color: ColorManager.gray,
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                    ),
                  ),
                  MyTextButton(
                    withIcon: true,
                    icon: FontAwesomeIcons.trash,
                    widthFactor: 0.2,
                    text: "Remove",
                    color: ColorManager.error.withOpacity(0.6),
                    size: 14,
                    heightFactor: 0.03,
                    onTap: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        useRootNavigator: true,
                        builder: (context) =>
                            RemoveProductMaterialSheet(product: widget.product),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RemoveProductMaterialSheet extends StatelessWidget {
  const RemoveProductMaterialSheet({Key? key, required this.product})
      : super(key: key);
  final BasketProductModel product;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) => Container(
        height: kHeight * 0.3,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1.0,
              spreadRadius: 1.0,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyText(
                    text: "Remove product from cart?",
                    size: 18,
                    color: Colors.black,
                  ),
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.clear)),
                ],
              ),
              const Spacer(flex: 4),
              SolidButton(
                radius: 10,
                text: "Don't remove",
                color: Colors.black,
                splashColor: ColorManager.primary,
                heightFactor: 0.06,
                widthFactor: 0.9,
                backgroundColor: Colors.white,
                borderColor: Colors.black45,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              SolidButton(
                radius: 10,
                text: "Remove",
                color: ColorManager.error,
                splashColor: ColorManager.primary,
                heightFactor: 0.06,
                widthFactor: 0.9,
                backgroundColor: Colors.white,
                borderColor: ColorManager.error,
                child: state is ShopLoadingRemoveFromCartState &&
                        state.id == product.id
                    ? MyLoadingIndicator(
                        height: kHeight * 0.05,
                        width: kWidth * 0.1,
                        indicatorType: Indicator.ballBeat,
                      )
                    : null,
                onTap: () async {
                  await ShopCubit.get(context)
                      .removeFromCart(product)
                      .then((value) => Navigator.pop(context));
                },
              ),
              const Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubtitleText(text: "Not sure yet?"),
                  kHSeparator(),
                  MyTextButton(
                    withIcon: true,
                    icon: FontAwesomeIcons.heart,
                    text: "Save for later",
                    color: ColorManager.info.withOpacity(0.6),
                    size: 16,
                    heightFactor: 0.04,
                    onTap: () async {
                      await ShopCubit.get(context)
                          .removeFromCart(product)
                          .then((value) => Navigator.pop(context));
                      if (!ShopCubit.get(context)
                          .favoritesProductsIds
                          .contains(product.id!)) {
                        ShopCubit.get(context).changeFavorites(product.id!);
                      }
                    },
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
