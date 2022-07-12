import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/account_cubit/account_states.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/business_logic/user_cubit/user_states.dart';
import 'package:graduation_project/data/models/order_model.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';
import 'package:loading_indicator/loading_indicator.dart';

class OrderConfirmedView extends StatelessWidget {
  const OrderConfirmedView({Key? key, required this.orderModel})
      : super(key: key);
  final OrderModel? orderModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AccountCubit, AccountStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final accountCubit = AccountCubit.get(context);
          return BlocConsumer<UserCubit, UserStates>(
            listener: (context, state) {},
            builder: (context, state) {
              final userModel = UserCubit.get(context).userModel;
              return BlocConsumer<ShopCubit, ShopStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  final shopCubit = ShopCubit.get(context);
                  return ConditionalBuilder(
                    condition:
                        accountCubit.addressModel != null && userModel != null,
                    builder: (context) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  BodyText(
                                    text:
                                        'Thank You for your order, ${nameHandler(userModel?.name ?? "")}',
                                    size: 14,
                                    color: ColorManager.black,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "You'll receive an email at ",
                                          style: kTheme.textTheme.caption!
                                              .copyWith(
                                                  color: ColorManager.dark),
                                        ),
                                        TextSpan(
                                          text: userModel?.email,
                                          style: kTheme.textTheme.headline5,
                                        ),
                                        TextSpan(
                                          text: " once your order is confirmed",
                                          style: kTheme.textTheme.caption!
                                              .copyWith(
                                                  color: ColorManager.dark),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  kVSeparator(),
                                  SolidButton(
                                      text: "Continue Shopping".toUpperCase(),
                                      color: Colors.white,
                                      heightFactor: 0.06,
                                      radius: 5,
                                      size: 16,
                                      onTap: () {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        tabController.index = 0;
                                      })
                                ],
                              ),
                              kVSeparator(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BodyText(
                                    text: "Order #${orderModel?.orderId}",
                                    color: ColorManager.dark,
                                  ),
                                  kVSeparator(factor: 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (var i = 0; i < 4; i++) ...[
                                        Container(
                                          height: 3,
                                          width: kWidth * 0.22,
                                          color: i == 0
                                              ? ColorManager.success
                                              : ColorManager.gray,
                                        ),
                                        kHSeparator(factor: 0.01),
                                      ]
                                    ],
                                  ),
                                  kVSeparator(factor: 0.01),
                                  BodyText(
                                      text:
                                          orderModel?.shipping?.toUpperCase() ??
                                              "",
                                      size: 14),
                                ],
                              ),
                              kVSeparator(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BodyText(
                                      text: "Shipping Address".toUpperCase(),
                                      color: ColorManager.dark),
                                  kVSeparator(factor: 0.01),
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.locationDot,
                                        color: ColorManager.subtitle,
                                        size: 16,
                                      ),
                                      kHSeparator(),
                                      BodyText(
                                          text: "Address",
                                          color: ColorManager.dark),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SubtitleText(
                                          text: formatText(
                                              accountCubit.addressModel?.name),
                                          color: ColorManager.dark,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${formatText(accountCubit.addressModel?.region)} - ',
                                                style: kTheme.textTheme.caption,
                                              ),
                                              TextSpan(
                                                text:
                                                    '${formatText(accountCubit.addressModel?.city)} - ',
                                                style: kTheme.textTheme.caption,
                                              ),
                                              TextSpan(
                                                text: formatText(accountCubit
                                                    .addressModel?.zipCode),
                                                style: kTheme.textTheme.caption,
                                              ),
                                              TextSpan(
                                                text:
                                                    '${accountCubit.addressModel!.details!.length > 1 ? " - " : ""} ${formatText(accountCubit.addressModel?.details)}',
                                                style: kTheme.textTheme.caption!
                                                    .copyWith(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SubtitleText(
                                          text: formatText(
                                              accountCubit.addressModel?.phone),
                                          color: ColorManager.dark,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              kVSeparator(factor: 0.04),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BodyText(
                                      text: "PAYMENT METHOD",
                                      color: ColorManager.black),
                                  kVSeparator(),
                                  Row(
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.creditCard,
                                        size: 16,
                                      ),
                                      kHSeparator(),
                                      SubtitleText(
                                        text: shopCubit.getPaymentNameById(),
                                        color: ColorManager.dark,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              kVSeparator(factor: 0.04),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BodyText(
                                      text: "ORDER SUMMARY",
                                      color: ColorManager.black),
                                  kVSeparator(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SubtitleText(text: "Subtotal"),
                                          const SizedBox(height: 10),
                                          SubtitleText(text: "Shipping Fee")
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SubtitleText(
                                              text:
                                                  "${formatPrice(orderModel?.subtotal ?? 0)} EGP"),
                                          const SizedBox(height: 10),
                                          SubtitleText(
                                              text:
                                                  "${orderModel?.shippingPrice ?? 0} EGP"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  kDivider(factor: 0.01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BodyText(
                                          text: "TOTAL",
                                          color: ColorManager.black),
                                      BodyText(
                                          text:
                                              "${formatPrice((orderModel?.subtotal ?? 0) + ShopCubit.get(context).getDeliveryPrice().toInt())} EGP",
                                          color: ColorManager.black),
                                    ],
                                  ),
                                  kDivider(factor: 0.01),
                                ],
                              ),
                              kVSeparator(factor: 0.04),
                              BodyText(
                                text: "PRODUCTS ORDERED",
                                color: ColorManager.black,
                              ),
                              kVSeparator(),
                              ...List.generate(
                                orderModel!.orderItems!.length,
                                (index) => Column(
                                  children: [
                                    CreateOrderSummaryItem(
                                      product: orderModel!.orderItems![index],
                                    ),
                                    if (index !=
                                        orderModel!.orderItems!.length - 1)
                                      kDivider(factor: 0.02, opacity: 0.3),
                                  ],
                                ),
                              ),
                              kVSeparator(factor: 0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                    fallback: (context) => Center(
                        child: MyLoadingIndicator(
                            indicatorType: Indicator.ballSpinFadeLoader)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CreateOrderSummaryItem extends StatelessWidget {
  CreateOrderSummaryItem({Key? key, required this.product}) : super(key: key);
  final OrderItems product;
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
                  BodyText(
                    text: product.productName ?? "",
                    color: ColorManager.dark,
                    size: 14,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "EGP ${formatPrice(product.price)}",
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
              image: NetworkImage(product.pictureUrl ?? ""),
              width: kWidth * 0.25,
              height: kHeight * 0.1,
            ),
          ],
        ),
        kVSeparator(),
        ProductDetailsHelpers.deliverBy(),
      ],
    );
  }
}
