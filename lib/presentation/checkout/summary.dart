import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/account_cubit/account_states.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/basket_model.dart';
import 'package:graduation_project/presentation/account/address_view.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AccountCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.addressModel != null,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: BlocConsumer<ShopCubit, ShopStates>(
              listener: (context, state) {},
              builder: (context, state) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BodyText(
                              text: "Ship to".toUpperCase(),
                              color: ColorManager.dark),
                          MyTextButton(
                            text: "Change Address",
                            color: ColorManager.blue,
                            size: 16,
                            onTap: () => showEditInfoSheet(context,
                                child: AddressView()),
                          ),
                        ],
                      ),
                      kVSeparator(),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            color: ColorManager.subtitle,
                            size: 16,
                          ),
                          kHSeparator(),
                          BodyText(text: "Address", color: ColorManager.dark),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubtitleText(
                              text: formatText(cubit.addressModel?.name),
                              color: ColorManager.dark,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${formatText(cubit.addressModel?.region)} - ',
                                    style: kTheme.textTheme.caption,
                                  ),
                                  TextSpan(
                                    text:
                                        '${formatText(cubit.addressModel?.city)} - ',
                                    style: kTheme.textTheme.caption,
                                  ),
                                  TextSpan(
                                    text:
                                        formatText(cubit.addressModel?.zipCode),
                                    style: kTheme.textTheme.caption,
                                  ),
                                  TextSpan(
                                    text:
                                        '${cubit.addressModel!.details!.length > 1 ? " - " : ""} ${formatText(cubit.addressModel?.details)}',
                                    style: kTheme.textTheme.caption!.copyWith(),
                                  ),
                                ],
                              ),
                            ),
                            SubtitleText(
                              text: formatText(cubit.addressModel?.phone),
                              color: ColorManager.dark,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  kGrayDivider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyText(
                          text: "PAYMENT METHOD", color: ColorManager.black),
                      kVSeparator(),
                      RadioListTile<int>(
                        value: 1,
                        groupValue: ShopCubit.get(context).paymentMethodId,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BodyText(
                                text: "Pay with Cash",
                                color: ColorManager.dark),
                            FaIcon(
                              FontAwesomeIcons.sackDollar,
                              color: ColorManager.subtitle,
                            ),
                          ],
                        ),
                        onChanged: (int? value) {
                          ShopCubit.get(context).changePaymentMethodId(value);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      kDivider(factor: 0.001),
                      RadioListTile<int>(
                        value: 2,
                        groupValue: ShopCubit.get(context).paymentMethodId,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BodyText(
                                text: "Pay with Card",
                                color: ColorManager.dark),
                            FaIcon(
                              FontAwesomeIcons.creditCard,
                              color: ColorManager.subtitle,
                            ),
                          ],
                        ),
                        onChanged: (int? value) {
                          ShopCubit.get(context).changePaymentMethodId(value);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  kGrayDivider(),
                  Container(
                    width: kWidth,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xfffdf7eb),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyText(
                            text: "ORDER SUMMARY", color: ColorManager.black),
                        kVSeparator(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SubtitleText(text: "Subtotal"),
                                const SizedBox(height: 10),
                                SubtitleText(text: "Shipping Fee")
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    BodyText(
                                        text: formatPrice(ShopCubit.get(context)
                                                .cartTotalPrice())
                                            .toString()),
                                    SubtitleText(text: " EGP"),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    BodyText(
                                        text: ShopCubit.get(context)
                                            .getDeliveryPrice()
                                            .toString()),
                                    SubtitleText(text: " EGP"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        kDivider(factor: 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BodyText(text: "Total"),
                            Row(
                              children: [
                                BodyText(
                                    text: ShopCubit.get(context)
                                        .getPriceWithDelivery()
                                        .toString()),
                                SubtitleText(text: " EGP"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  kGrayDivider(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: BodyText(
                        text: "REVIEW YOUR ORDER", color: ColorManager.black),
                  ),
                  kGrayDivider(),
                  ...List.generate(
                    ShopCubit.get(context).cartProducts.length,
                    (index) => Column(
                      children: [
                        OrderSummaryItem(
                          product: ShopCubit.get(context).cartProducts[index],
                        ),
                        if (index !=
                            ShopCubit.get(context).cartProducts.length - 1)
                          kDivider(factor: 0.02, opacity: 0.3),
                      ],
                    ),
                  ),
                  kGrayDivider(),
                  kVSeparator(factor: 0.05),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: const MyLoadingIndicator()),
        );
      },
    );
  }

  String formatText(String? text) {
    if (text != null && text.length > 1) return text;
    return "";
  }
}

class OrderSummaryItem extends StatelessWidget {
  OrderSummaryItem({Key? key, required this.product}) : super(key: key);
  final BasketProductModel product;
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
                  Text(
                    "EGP ${formatPrice(product.price!)}",
                    style: TextStyle(
                      fontSize: 20,
                      color: ColorManager.dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SubtitleText(text: "QTY ${this.product.quantity}"),
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
      ],
    );
  }
}
