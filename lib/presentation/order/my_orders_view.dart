import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../business_logic/shop_cubit/shop_cubit.dart';
import '../../business_logic/shop_cubit/shop_states.dart';
import '../../data/models/order_model.dart';
import '../../shared/constants.dart';
import '../../shared/helpers.dart';
import '../../shared/resources/assets_manager.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/indicators.dart';
import 'order_details_view.dart';
import 'review_order_sheet.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({Key? key}) : super(key: key);

  buildNoOrdersWidget(context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageAssets.orderEmpty,
              height: kHeight * 0.3,
            ),
            kVSeparator(),
            BodyText(
                text: "Your don't have any orders yet!",
                size: 18,
                align: TextAlign.center,
                color: ColorManager.black),
            kVSeparator(factor: 0.01),
            Container(
              width: kWidth * 0.9,
              child: SubtitleText(
                text: "What are you waiting for? Start shopping",
                color: ColorManager.subtitle,
                align: TextAlign.center,
              ),
            ),
            kVSeparator(factor: 0.05),
            SolidButton(
              radius: 10,
              text: "Start Shopping",
              heightFactor: 0.07,
              backgroundColor: Colors.white,
              color: ColorManager.black,
              widthFactor: 0.9,
              borderColor: ColorManager.black,
              onTap: () {
                Navigator.pop(context);
                tabController.index = 0;
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: cubit.userOrders.isNotEmpty
                ? Row(
                    children: [
                      BodyText(
                        text: "My Orders",
                        color: ColorManager.dark,
                        size: 18,
                      ),
                      kHSeparator(),
                      CircleAvatar(
                        backgroundColor: ColorManager.lightGray,
                        radius: 12,
                        child: Text(
                          "${ShopCubit.get(context).userOrders.length}",
                          style: kTheme.textTheme.bodyText2!.copyWith(
                            color: ColorManager.black,
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          body: ConditionalBuilder(
            condition: cubit.userOrders.isNotEmpty,
            builder: (context) {
              final userOrders = cubit.userOrders;
              return ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: userOrders.length,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    buildOrderItem(userOrders[index], context),
                separatorBuilder: (context, index) => kGrayDivider(),
              );
            },
            fallback: (context) => buildNoOrdersWidget(context),
          ),
        );
      },
    );
  }

  buildOrderItem(OrderModel order, context) => Container(
        height: order.orderStatus == OrderStatus.delivered
            ? kHeight * 0.35
            : kHeight * 0.28,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BodyText(
                          text: "Order ${order.orderId?.toUpperCase()}",
                          color: ColorManager.dark),
                      Row(
                        children: [
                          MyTextButton(
                            color: ColorManager.info,
                            text: "View Details",
                            onTap: () => push(
                                context, OrderDetailsView(orderModel: order)),
                          ),
                          const SizedBox(width: 5),
                          FaIcon(
                            FontAwesomeIcons.chevronRight,
                            size: 14,
                            color: ColorManager.info,
                          )
                        ],
                      ),
                    ],
                  ),
                  SubtitleText(
                      text: "Placed On ${parseDateTime(order.orderDate!)}")
                ],
              ),
              kDivider(),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => SizedBox(
                    width: kWidth * 0.7,
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: order.orderItems![index].pictureUrl!,
                          width: kWidth * 0.2,
                          height: kHeight * 0.1,
                          placeholder: (context, url) =>
                              const MyLoadingIndicator(
                            circular: true,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: kWidth * 0.4,
                              child: SubtitleText(
                                text: order.orderItems![index].productName!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 15),
                  itemCount: order.orderItems!.length,
                ),
              ),
              kVSeparator(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: BodyText(
                  text: order.shipping!,
                  size: 14,
                  color: order.orderStatus == OrderStatus.cancelled
                      ? ColorManager.error
                      : ColorManager.success,
                ),
              ),
              if (order.orderStatus == OrderStatus.delivered) ...[
                kVSeparator(),
                SolidButton(
                  color: ColorManager.blue,
                  backgroundColor: Colors.white,
                  borderColor: ColorManager.blue,
                  text: "Review this order",
                  isBold: false,
                  withIcon: true,
                  icon: FontAwesomeIcons.thumbsUp,
                  heightFactor: 0.04,
                  widthFactor: 0.4,
                  size: 12,
                  radius: 5,
                  onTap: () {
                    showMaterialModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      useRootNavigator: true,
                      builder: (context) =>
                          ReviewOrderMaterialSheet(orderModel: order),
                    ).then((value) {
                      // Navigator.pop(context);
                    });
                  },
                ),
              ]
            ],
          ),
        ),
      );
}
