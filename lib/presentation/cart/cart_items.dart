import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/basket_model.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';

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
                    SubtitleText(
                      text: " (${ShopCubit.get(context).cartProducts.length} item" +
                          "${ShopCubit.get(context).cartProducts.length > 1 ? "s" : ""}" +
                          ")",
                      size: 14,
                    ),
                  ],
                ),
                kVSeparator(factor: 0.03),
                Column(
                  children: List.generate(
                      ShopCubit.get(context).cartProducts.length,
                      (index) => CartItemWidget(
                            product: ShopCubit.get(context).cartProducts[index],
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

class CartItemWidget extends StatefulWidget {
  CartItemWidget({Key? key, required this.product}) : super(key: key);
  final BasketProductModel product;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  List<String> items = ['1', '2', '3'];
  String? selectedItem = '1';
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
                value: selectedItem,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
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
                    onTap: () => print("add"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      height: 30,
                      child: VerticalDivider(
                        color: ColorManager.info,
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
                    color: ColorManager.info.withOpacity(0.6),
                    size: 14,
                    heightFactor: 0.04,
                    onTap: () => ShopCubit.get(context)
                        .removeFavoriteProduct(widget.product.id!),
                  ),
                ],
              ),
            ],
          ),
        ),
        kDivider(factor: 0.02, opacity: 0.3),
      ],
    );
  }
}
