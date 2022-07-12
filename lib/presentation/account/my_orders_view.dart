import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/order_model.dart';
import 'package:graduation_project/presentation/account/order_details_view.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
        height: kHeight * 0.25,
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
                          text: "Order #${order.orderId}",
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
                                  indicatorType: Indicator.ballSpinFadeLoader),
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
                            const SizedBox(height: 5),
                            BodyText(
                              text: order.shipping!.toUpperCase(),
                              color: ColorManager.success,
                            )
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
            ],
          ),
        ),
      );
}
