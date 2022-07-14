import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/order_model.dart';
import 'package:graduation_project/presentation/order/cancel_order_sheet.dart';
import 'package:graduation_project/presentation/order/order_details_summary.dart';
import 'package:graduation_project/presentation/order/review_order_sheet.dart';
import 'package:graduation_project/shared/components.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OrderDetailsView extends StatelessWidget {
  OrderDetailsView({Key? key, required this.orderModel}) : super(key: key);

  OrderModel? orderModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if (state is ShopErrorCancelOrderState) {
            showToast(
                msg: ShopCubit.get(context).successMessage,
                state: ToastStates.SUCCESS);
          }
          if (state is ShopErrorCancelOrderState) {
            showToast(
                msg: ShopCubit.get(context).errorMessage,
                state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          orderModel = ShopCubit.get(context)
              .userOrders
              .firstWhere((element) => element.id == orderModel?.id);
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
                              text:
                                  "ORDER ID - ${orderModel?.orderId?.toUpperCase()}",
                              color: ColorManager.dark,
                            ),
                            SubtitleText(
                              text:
                                  "Placed On ${parseDateTime(orderModel!.orderDate!, withTime: true)}",
                              size: 12,
                            )
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
                                  text: "Address", color: ColorManager.dark),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SubtitleText(
                                  text: formatText(
                                      orderModel?.shipToAddress?.name),
                                  color: ColorManager.dark,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${formatText(orderModel?.shipToAddress?.region)} - ',
                                        style: kTheme.textTheme.caption,
                                      ),
                                      TextSpan(
                                        text:
                                            '${formatText(orderModel?.shipToAddress?.city)} - ',
                                        style: kTheme.textTheme.caption,
                                      ),
                                      TextSpan(
                                        text: formatText(
                                            orderModel?.shipToAddress?.zipCode),
                                        style: kTheme.textTheme.caption,
                                      ),
                                      TextSpan(
                                        text:
                                            '${orderModel!.shipToAddress!.details!.length > 1 ? " - " : ""} ${formatText(orderModel?.shipToAddress?.details)}',
                                        style: kTheme.textTheme.caption!
                                            .copyWith(),
                                      ),
                                    ],
                                  ),
                                ),
                                SubtitleText(
                                  text: formatText(
                                      orderModel?.shipToAddress?.phone),
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
                              text: "SHIPPING METHOD",
                              color: ColorManager.black),
                          kVSeparator(),
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.ship,
                                size: 16,
                              ),
                              kHSeparator(),
                              SubtitleText(
                                text: orderModel!.deliveryMethod!,
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
                                text: orderModel!.paymentMethod!,
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
                                  SubtitleText(
                                      text:
                                          "${formatPrice(orderModel?.subtotal ?? 0)} EGP"),
                                  const SizedBox(height: 10),
                                  SubtitleText(
                                      text: "${orderModel?.shippingPrice} EGP"),
                                ],
                              ),
                            ],
                          ),
                          kDivider(factor: 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BodyText(
                                  text: "TOTAL", color: ColorManager.black),
                              BodyText(
                                  text: "${formatPrice(orderModel?.total)} EGP",
                                  color: ColorManager.black),
                            ],
                          ),
                          kDivider(factor: 0.01),
                        ],
                      ),
                      if (orderModel?.orderStatus == OrderStatus.Delivered) ...[
                        kVSeparator(),
                        SolidButton(
                          color: ColorManager.blue,
                          backgroundColor: Colors.white,
                          borderColor: ColorManager.blue,
                          text: "Review this order",
                          isBold: false,
                          heightFactor: 0.06,
                          size: 16,
                          radius: 5,
                          onTap: () {
                            showMaterialModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              useRootNavigator: true,
                              builder: (context) => ReviewOrderMaterialSheet(
                                  orderModel: orderModel!),
                            ).then((value) {
                              // Navigator.pop(context);
                            });
                          },
                        ),
                        kVSeparator(),
                      ],
                      if (orderModel?.orderStatus != OrderStatus.Cancelled)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kVSeparator(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var i = 0; i < 4; i++) ...[
                                  Container(
                                    height: 3,
                                    width: kWidth * 0.22,
                                    color: i <=
                                            (orderModel?.orderStatus?.index ??
                                                0)
                                        ? ColorManager.success
                                        : ColorManager.gray,
                                  ),
                                  kHSeparator(factor: 0.01),
                                ]
                              ],
                            ),
                            kVSeparator(factor: 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BodyText(
                                    text: orderModel?.shipping ?? "",
                                    size: 16,
                                    color: ColorManager.success),
                                if (orderModel?.orderStatus ==
                                    OrderStatus.Delivered)
                                  Row(
                                    children: [
                                      BodyText(
                                        text: "Delivered on ",
                                        color: Colors.black87,
                                        size: 12,
                                      ),
                                      BodyText(
                                          text: ProductDetailsHelpers
                                              .shippingDate(
                                                  dateTime: DateTime.parse(
                                                      orderModel!.orderDate!),
                                                  Duration(days: 5)),
                                          size: 12,
                                          color: ColorManager.success),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        )
                      else
                        BodyText(
                            text: orderModel?.shipping ?? "",
                            size: 16,
                            color: ColorManager.error),
                      kVSeparator(factor: 0.04),
                      if (orderModel?.orderStatus != OrderStatus.Cancelled &&
                          orderModel?.orderStatus != OrderStatus.Delivered) ...[
                        SolidButton(
                          color: ColorManager.error,
                          backgroundColor: Colors.white,
                          borderColor: ColorManager.error,
                          text: "Cancel this order",
                          isBold: false,
                          heightFactor: 0.06,
                          radius: 5,
                          onTap: () {
                            showMaterialModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              useRootNavigator: true,
                              builder: (context) => CancelOrderMaterialSheet(
                                  orderModel: orderModel!),
                            ).then((value) {
                              // Navigator.pop(context);
                            });
                          },
                        ),
                        kVSeparator(factor: 0.04),
                      ],
                      Container(
                        foregroundDecoration:
                            orderModel?.orderStatus == OrderStatus.Cancelled
                                ? BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    backgroundBlendMode: BlendMode.lighten,
                                  )
                                : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyText(
                              text: "PRODUCTS ORDERED",
                              color: ColorManager.black,
                            ),
                            kVSeparator(),
                            ...List.generate(
                              orderModel!.orderItems!.length,
                              (index) => Column(
                                children: [
                                  OrderDetailsSummaryItem(
                                    orderItem: orderModel!.orderItems![index],
                                    orderModel: orderModel!,
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
