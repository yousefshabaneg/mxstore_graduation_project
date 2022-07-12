import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/business_logic/user_cubit/user_states.dart';
import 'package:graduation_project/data/models/order_model.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({Key? key, required this.orderModel})
      : super(key: key);

  final OrderModel orderModel;

  buildOrderStatus() {
    return Column(
      children: [
        kVSeparator(factor: 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 4; i++) ...[
              Container(
                height: 3,
                width: kWidth * 0.22,
                color: i == 0 ? ColorManager.success : ColorManager.gray,
              ),
              kHSeparator(factor: 0.01),
            ]
          ],
        ),
        kVSeparator(factor: 0.01),
        const BodyText(text: "ORDERED", size: 12)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final userModel = UserCubit.get(context).userModel;
          return BlocConsumer<ShopCubit, ShopStates>(
            listener: (context, state) {},
            builder: (context, state) {
              final shopCubit = ShopCubit.get(context);
              return Scaffold(
                appBar: AppBar(),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                BodyText(
                                  text: "ORDER ID - #${orderModel.orderId}",
                                  color: ColorManager.dark,
                                ),
                                SubtitleText(
                                    text:
                                        "Placed On ${parseDateTime(orderModel.orderDate!, withTime: true)}")
                              ],
                            ),
                          ),
                          kDivider(factor: 0.02),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SubtitleText(
                                      text: formatText(
                                          orderModel.shipToAddress?.name),
                                      color: ColorManager.dark,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${formatText(orderModel.shipToAddress?.region)} - ',
                                            style: kTheme.textTheme.caption,
                                          ),
                                          TextSpan(
                                            text:
                                                '${formatText(orderModel.shipToAddress?.city)} - ',
                                            style: kTheme.textTheme.caption,
                                          ),
                                          TextSpan(
                                            text: formatText(orderModel
                                                .shipToAddress?.zipCode),
                                            style: kTheme.textTheme.caption,
                                          ),
                                          TextSpan(
                                            text:
                                                '${orderModel.shipToAddress!.details!.length > 1 ? " - " : ""} ${formatText(orderModel.shipToAddress?.details)}',
                                            style: kTheme.textTheme.caption!
                                                .copyWith(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SubtitleText(
                                      text: formatText(
                                          orderModel.shipToAddress?.phone),
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
                                    text: orderModel.status!,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SubtitleText(
                                          text:
                                              "${formatPrice(orderModel.subtotal ?? 0)} EGP"),
                                      const SizedBox(height: 10),
                                      SubtitleText(
                                          text:
                                              "${orderModel.shippingPrice} EGP"),
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
                                      text: "TOTAL", color: ColorManager.black),
                                  BodyText(
                                      text:
                                          "${formatPrice((orderModel.subtotal ?? 0) + ShopCubit.get(context).getDeliveryPrice().toInt())} EGP",
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
                            orderModel.orderItems!.length,
                            (index) => Column(
                              children: [
                                OrderDetailsSummaryItem(
                                  orderItem: orderModel.orderItems![index],
                                ),
                                if (index != orderModel.orderItems!.length - 1)
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
              );
            },
          );
        },
      ),
    );
  }
}

class OrderDetailsSummaryItem extends StatelessWidget {
  const OrderDetailsSummaryItem({Key? key, required this.orderItem})
      : super(key: key);
  final OrderItems orderItem;
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
                    text: orderItem.productName ?? "",
                    color: ColorManager.dark,
                    size: 14,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "EGP ${formatPrice(orderItem.price!.toInt())}",
                    style: TextStyle(
                      fontSize: 20,
                      color: ColorManager.dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SubtitleText(text: "QTY ${this.orderItem.quantity}"),
                ],
              ),
            ),
            Image(
              image: NetworkImage(orderItem.pictureUrl ?? ""),
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
